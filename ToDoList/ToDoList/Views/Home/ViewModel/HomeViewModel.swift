import UIKit

final class HomeViewModel {

    // MARK: - Public properties

    weak var view: HomeViewControllerProtocol?

    var data: [TodoViewModel] = [] {
        didSet {
            Task {
                await setupHeader()
            }
        }
    }

    // MARK: - private properties

    private var isHidden = true

    private let fileName = "development.json"

    private lazy var fileCache: FileCacheProtocol = FileCache(fileName: fileName)
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

        let isExist = data.contains { $0.item.id == newItem.id }
        if isExist {
            try? fileCache.change(item: newItem)
        } else {
            data.append(model)
            try? fileCache.add(item: newItem)
        }

        try? fileCache.saveItems(to: fileName)
        view?.items = data
        view?.reloadData()
    }

    @MainActor func didDelete(model: TodoViewModel) {
        try? fileCache.removeItem(by: model.item.id)
        try? fileCache.saveItems(to: fileName)
        data.removeAll { $0.item.id == model.item.id }
        view?.items = data
        view?.reloadData()
    }
}

// MARK: - HomeViewModelProtocol

extension HomeViewModel: HomeViewModelProtocol {

    @MainActor func createTask(with text: String) {
        let newModel = TodoViewModel(item: TodoItem(text: text))
        data.append(newModel)
        try? fileCache.add(item: newModel.item)
        try? fileCache.saveItems(to: fileName)
        view?.items = data
        view?.insertRow(at: IndexPath(row: data.count - 1, section: 0))
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

    func viewDidLoad() {
        fetchItems()
    }

    func fetchItems() {
        try? fileCache.loadItems(from: fileName)

        if fileCache.items.isEmpty {
            let startArray = getStartArray()
            startArray.forEach {
                try? fileCache.add(item: $0)
            }
            try? fileCache.saveItems(to: fileName)
        }

        data = fileCache.items.map { TodoViewModel(item: $0) }
        data.forEach {
            $0.delegate = self
        }
        view?.items = data
    }

    @MainActor func delete(at indexPath: IndexPath) {
        guard let view = view else { return }
        let id = view.items[indexPath.row].item.id
        if !isHidden {
            try? fileCache.removeItem(by: id)
            try? fileCache.saveItems(to: fileName)
            data.removeAll { $0.item.id == id }
            view.items.remove(at: indexPath.row)
            view.deleteRow(at: indexPath)
        } else {
            try? fileCache.removeItem(by: data[indexPath.row].item.id)
            try? fileCache.saveItems(to: fileName)
            data.remove(at: indexPath.row)
            view.items = data
            view.deleteRow(at: indexPath)
        }
        setupHeader()
    }

    @MainActor func toggleStatus(on model: TodoViewModel, at: IndexPath) {
        guard let view = view else { return }
        if !isHidden {
            model.state.isFinished.toggle()
            model.item = model.item.toggleComplete()
            try? fileCache.change(item: model.item)
            try? fileCache.saveItems(to: fileName)
            view.items.remove(at: at.row)
            view.deleteRow(at: at)
        } else {
            model.state.isFinished.toggle()
            model.item = model.item.toggleComplete()
            try? fileCache.change(item: model.item)
            try? fileCache.saveItems(to: fileName)
            view.reloadRow(at: at)
        }
        setupHeader()
    }

    @MainActor func setupHeader() {
        let filtered = data.filter { $0.item.isFinished }
        let amount = filtered.count
        view?.setupHeader(title: isHidden ? "Показать" : "Скрыть", amount: amount)
    }
}

// MARK: - Private methods

private extension HomeViewModel {
    
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
