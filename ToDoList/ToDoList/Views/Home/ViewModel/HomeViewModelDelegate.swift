import Foundation

protocol HomeViewModelDelegate: AnyObject {
    
    @MainActor func didUpdate(model: TodoViewModel, state: TodoViewState)

    @MainActor func didDelete(model: TodoViewModel)
}
