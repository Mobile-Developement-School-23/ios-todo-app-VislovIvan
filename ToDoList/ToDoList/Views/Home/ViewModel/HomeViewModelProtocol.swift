import Foundation

protocol HomeViewModelProtocol: AnyObject {

    var view: HomeViewControllerProtocol? { get set }

    var data: [TodoViewModel] { get set }

    func viewDidLoad()

    func createTask(with text: String)

    func delete(at indexPath: IndexPath)

    func toggleStatus(on model: TodoViewModel, at: IndexPath)

    func openModal(with model: TodoViewModel?)

    func openInfoModal(with model: TodoViewModel?)

    func toggleCompletedTasks()

    func setupHeader()
}
