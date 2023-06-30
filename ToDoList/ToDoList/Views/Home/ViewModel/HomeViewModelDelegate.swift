import Foundation

protocol HomeViewModelDelegate: AnyObject {
    
    func didUpdate(model: TodoViewModel, state: TodoViewState)

    func didDelete(model: TodoViewModel)
}
