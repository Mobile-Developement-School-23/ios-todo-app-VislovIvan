import Foundation

protocol HomeViewModelDelegate: AnyObject {

    /// Оповестить об изменении таски
    /// - Parameters:
    ///   - model: Вью модель
    ///   - state: Стейт
    func didUpdate(model: TodoViewModel, state: TodoViewState)

    /// Оповестить об удалении таски
    /// - Parameter model: Вью модель
    func didDelete(model: TodoViewModel)
}
