import Foundation

protocol HomeViewModelProtocol: AnyObject {

    var view: HomeViewControllerProtocol? { get set }

    var data: [TodoViewModel] { get set }

    func viewDidLoad()

    @MainActor func createTask(with text: String)

    @MainActor func delete(at indexPath: IndexPath)

    @MainActor func toggleCompletedTasks()

    @MainActor func toggleStatus(on model: TodoViewModel, at: IndexPath)

    @MainActor func openModal(with model: TodoViewModel?)

    @MainActor func openInfoModal(with model: TodoViewModel?)

    @MainActor func setupHeader()
}
