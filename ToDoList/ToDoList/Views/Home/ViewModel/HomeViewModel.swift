import UIKit
import CocoaLumberjackSwift

final class HomeViewModel {

    // MARK: - Public properties

    weak var view: HomeViewControllerProtocol?

    var data: [TodoViewModel] = [] {
        didSet {
//            Task {
//                await setupHeader()
//            }
            DispatchQueue.main.async {
                self.setupHeader()
            }
        }
    }

    // MARK: - private properties
    
    private var isHidden = true
    
    private let fileName = "development.json"
    
    private lazy var fileCache: FileCacheServiceProtocol = FileCache(fileName: fileName)
    
    private let mockNetwork: NetworkServiceProtocol = MockNetworkService()
    
}

// MARK: - HomeViewModelDelegate

extension HomeViewModel: HomeViewModelDelegate {

    @MainActor func didUpdate(model: TodoViewModel, state: TodoViewState) {
        let newItem = TodoItem(
            id: model.item.id,
            text: state.text,
            importance: state.importance,
            deadline: state.deadline,
            isFinished: state.isFinished,
            createdAt: state.createdAt,
            changedAt: state.changedAt
        )

        mockNetwork.editTodoItem(newItem) { [weak self] res in
            switch res {
            case let .success(updatedItem):
                self?.update(with: updatedItem, model: model)
                DDLogError("Новый элемент успешно добавлен на стороне сервера")
                DispatchQueue.main.async {
                    self?.view?.reloadData()
                }
            case .failure:
                DDLogError("Ошибка обновления. Нет доступа к серверу")
            }
        }
    }

    @MainActor func didDelete(model: TodoViewModel) {
        mockNetwork.deleteTodoItem(at: model.item.id) { [weak self] res in
            switch res {
            case .success:
                guard let self = self else { return }
                try? self.fileCache.removeItem(by: model.item.id)
                self.saveItems()
                self.data.removeAll { $0.item.id == model.item.id }
                self.view?.items = self.data
                DDLogError("Элемент успешно удален на стороне сервера")
                DispatchQueue.main.async {
                    self.view?.reloadData()
                }
            case let .failure(error):
                DDLogError(error)
            }
        }
    }
}

// MARK: - HomeViewModelProtocol

extension HomeViewModel: HomeViewModelProtocol {
    
    func viewDidLoad() {
        fetchItems()
    }
    
    @MainActor func createTask(with text: String) {
        let newModel = TodoViewModel(item: TodoItem(text: text))
        data.append(newModel)
        try? fileCache.add(item: newModel.item)
        
        mockNetwork.editTodoItem(newModel.item) { [weak self] res in
            guard let self = self else { return }
            switch res {
            case .success:
                self.saveItems()
                self.view?.items = self.data
                DDLogError("Новый элемент успешно добавлен на стороне сервера")
                DispatchQueue.main.async {
                    self.view?.insertRow(at: IndexPath(row: self.data.count - 1, section: 0))
                }
            case .failure:
                DDLogError("Ошибка добавления. Нет доступа к серверу")
            }
        }
    }
    
    func delete(at indexPath: IndexPath) {
        guard let view = view else { return }
        let idx = isHidden ? data[indexPath.row].item.id : view.items[indexPath.row].item.id
        
        mockNetwork.deleteTodoItem(at: idx) { [weak self] res in
            guard let self = self else {
                DDLogError("error")
                return
            }
            switch res {
            case .success:
                if !self.isHidden {
                    let id = view.items[indexPath.row].item.id
                    try? self.fileCache.removeItem(by: id)
                    self.data.removeAll { $0.item.id == id }
                    view.items.remove(at: indexPath.row)
                } else {
                    try? self.fileCache.removeItem(by: self.data[indexPath.row].item.id)
                    self.data.remove(at: indexPath.row)
                    view.items = self.data
                }
                self.saveItems()
                DispatchQueue.main.async {
                    view.deleteRow(at: indexPath)
                }
            case let .failure(error):
                DDLogError(error)
            }
        }
        setupHeader()
    }

    @MainActor func toggleCompletedTasks() {
        let sorted = data.filter { !$0.item.isFinished }
        let cleaned = data.enumerated().compactMap { $0.element.item.isFinished ? $0.offset : nil }
        let indices = cleaned.compactMap { IndexPath(row: $0, section: 0) }

        if isHidden {
            view?.items = sorted
            view?.deleteRows(at: indices)
        } else {
            view?.items = data
            view?.insertRows(at: indices)
        }
        isHidden.toggle()
        setupHeader()
    }

    func toggleStatus(on model: TodoViewModel, at: IndexPath) {
        mockNetwork.editTodoItem(model.item) { [weak self] res in
            switch res {
            case .success:
                guard let self = self,
                      let view = self.view
                else { return }
                
                if !self.isHidden {
                    model.state.isFinished.toggle()
                    model.item = model.item.toggleComplete()
                    try? self.fileCache.change(item: model.item)
                    self.saveItems()
                    view.items.remove(at: at.row)
                } else {
                    model.state.isFinished.toggle()
                    model.item = model.item.toggleComplete()
                    try? self.fileCache.change(item: model.item)
                    self.saveItems()
                }
                DispatchQueue.main.async {
                    if !self.isHidden {
                        view.deleteRow(at: at)
                    } else {
                        view.reloadRow(at: at)
                    }
                    self.setupHeader()
                }
            case let .failure(error):
                DDLogError(error)
            }
        }
    }
    
    @MainActor
    func openModal(with model: TodoViewModel? = nil) {
        guard let model = model else {
            let newModel = TodoViewModel(item: TodoItem(text: ""))
            newModel.delegate = self
            let controller = TodoModalViewController(viewModel: newModel)
            newModel.modal = controller
            let navigationController = UINavigationController(rootViewController: controller)
            view?.present(modal: navigationController)
            return
        }

        let controller = TodoModalViewController(viewModel: model)
        model.modal = controller
        let navigationController = UINavigationController(rootViewController: controller)
        view?.present(modal: navigationController)
    }

    @MainActor
    func openInfoModal(with model: TodoViewModel? = nil) {
        guard let model = model else {
            let newModel = TodoViewModel(item: TodoItem(text: ""))
            newModel.delegate = self
            let controller = TodoModalViewController(viewModel: newModel)
            newModel.modal = controller
            let navigationController = UINavigationController(rootViewController: controller)
            let transitionDelegate = CustomModalTransitionDelegate()

            navigationController.transitioningDelegate = transitionDelegate
            navigationController.modalPresentationStyle = .custom

            view?.present(modal: navigationController)
            return
        }

        let controller = TodoModalViewController(viewModel: model)
        model.modal = controller
        let navigationController = UINavigationController(rootViewController: controller)
        let transitionDelegate = CustomModalTransitionDelegate()

        navigationController.transitioningDelegate = transitionDelegate
        navigationController.modalPresentationStyle = .custom

        view?.present(modal: navigationController)
    }
    
    func setupHeader() {
        let filtered = data.filter { $0.item.isFinished }
        let amount = filtered.count
        view?.setupHeader(title: isHidden ? "Показать" : "Скрыть", amount: amount)
    }
}

// MARK: - Private methods

private extension HomeViewModel {
    
    func fetchItems() {
        mockNetwork.getAllTodoItems { [weak self] res in
            switch res {
            case let .success(networkItems):
                DDLogInfo("Загрузили данные из сети. Обновляем кэш")
                networkItems.forEach {
                    try? self?.fileCache.add(item: $0)
                }
                self?.parse(items: networkItems)
            case .failure:
                DDLogError("Ошибка чтения данных из сети, читаем данные из файла")
                guard let filename = self?.fileName else { return }
                self?.fileCache.load(from: filename) { result in
                    switch result {
                    case let .success(fileItems):
                        DDLogInfo("Загрузили данные из файла")
                        self?.parse(items: fileItems)
                    case let .failure(error):
                        DDLogError(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - Save items
    
    func saveItems() {
        fileCache.save(to: fileName) { result in
            switch result {
            case .success:
                DDLogInfo("Данные успешно сохранены в файл")
            case let .failure(error):
                DDLogError(error)
            }
        }
    }
    
    func parse(items: [TodoItem]) {
        if items.isEmpty {
            DDLogInfo("Набор пустой. Создаем дефолтный")

            let startArray = getStartArray()
            startArray.forEach {
                try? fileCache.add(item: $0)
            }
        }
        saveItems()
        data = items.map { TodoViewModel(item: $0) }
        data.forEach {
            $0.delegate = self
        }
        view?.items = data
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.reloadData()
        }
    }
    
    func update(with item: TodoItem, model: TodoViewModel) {
        let isExist = data.contains { $0.item.id == item.id }
        if isExist {
            try? fileCache.change(item: item)
        } else {
            data.append(model)
            try? fileCache.add(item: item)
        }
        saveItems()
        view?.items = data
    }
    
    func getStartArray() -> [TodoItem] {
        return [
            TodoItem(
                text: "Купить что-то",
                importance: .normal,
                deadline: nil,
                isFinished: true
            ),
            TodoItem(
                text: "Купить что-то",
                importance: .normal,
                deadline: nil,
                isFinished: false
            ),
            TodoItem(
                text: "Купить что-то",
                importance: .unimportant,
                deadline: Date(timeIntervalSince1970: 1688241600),
                isFinished: false
            ),
            TodoItem(
                text: "Купить что-то",
                importance: .important,
                deadline: Date(timeIntervalSince1970: 1688500800),
                isFinished: false
            ),
            TodoItem(
                text: "Задание",
                importance: .important,
                deadline: nil,
                isFinished: true
            ),
            TodoItem(
                text: "Купить что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы что-то, где-то, зачем-то, но зачем не очень понятно, но точно чтобы",
                importance: .normal,
                deadline: Date(timeIntervalSince1970: 1688500800),
                isFinished: false
            ),
            TodoItem(
                text: "Купить сыр",
                importance: .unimportant,
                deadline: nil,
                isFinished: false
            ),
            TodoItem(
                text: "сделать зарядку",
                importance: .important,
                createdAt: Date(timeIntervalSince1970: 1688241600),
                changedAt: Date(timeIntervalSince1970: 1688241600)
            )
        ]
    }
}
