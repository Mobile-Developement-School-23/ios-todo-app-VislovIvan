import Foundation

protocol TodoModalProtocol: AnyObject {
    
    func configure(with state: TodoViewState)
    
    func closeModal(animated: Bool)
    
    func showCalendar()
    
    func dismissCalendar()
    
    func setupDeadline(with date: Date)
}

final class TodoViewModel {
    
    weak var modal: TodoModalProtocol?
    
    weak var delegate: HomeViewModelDelegate?
    
    var item: TodoItem
    
    lazy var state = TodoViewState(item: item) {
        didSet {
            modal?.configure(with: state)
        }
    }
    
    init(item: TodoItem) {
        self.item = item
    }
}

// MARK: - TodoViewModelProtocol

extension TodoViewModel: TodoViewModelProtocol {
    
    func deadlineDidChange(isEnabled: Bool) {
        state.deadline = isEnabled ? state.deadline ?? Date().dayAfter : nil
        isEnabled ? modal?.showCalendar() : modal?.dismissCalendar()
    }
    
    func deadLineDidClick() {
        if let deadline = state.deadline ?? Date().dayAfter {
            modal?.setupDeadline(with: deadline)
            modal?.showCalendar()
        }
    }
    
    func textDidChange(text: String) {
        state.text = text
    }
    
    func importanceDidChange(importance: Importance) {
        state.importance = importance
    }
    
    func datePickerChanged(date: Date) {
        state.deadline = date
    }
    
    func saveButtonDidTap() {
        modal?.closeModal(animated: true)
        delegate?.didUpdate(model: self, state: state)
    }
    
    func deleteButtonDidTap() {
        modal?.closeModal(animated: true)
        delegate?.didDelete(model: self)
    }
}
