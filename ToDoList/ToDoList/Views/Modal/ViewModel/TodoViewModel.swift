import Foundation

protocol TodoModalProtocol: AnyObject {
    
    func configure(with state: TodoViewState)
    
    @MainActor func closeModal(animated: Bool)
    
    @MainActor func showCalendar()
    
    @MainActor func dismissCalendar()
    
    @MainActor func setupDeadline(with date: Date)
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
    
    init(item: ApiTodoItem) {
        self.item = TodoViewModel.parse(item: item)
    }
}

// MARK: - TodoViewModelProtocol

extension TodoViewModel: TodoViewModelProtocol {
    
    @MainActor func deadlineDidChange(isEnabled: Bool) {
        state.deadline = isEnabled ? state.deadline ?? Date().dayAfter : nil
        isEnabled ? modal?.showCalendar() : modal?.dismissCalendar()
    }
    
    @MainActor func deadLineDidClick() {
        if let deadline = state.deadline ?? Date().dayAfter {
            modal?.setupDeadline(with: deadline)
            modal?.showCalendar()
        }
    }
    
    @MainActor func textDidChange(text: String) {
        state.text = text
    }
    
    @MainActor func importanceDidChange(importance: Importance) {
        state.importance = importance
    }
    
    @MainActor func datePickerChanged(date: Date) {
        state.deadline = date
    }
    
    @MainActor func saveButtonDidTap() {
        modal?.closeModal(animated: true)
        delegate?.didUpdate(model: self, state: state)
    }
    
    @MainActor func deleteButtonDidTap() {
        modal?.closeModal(animated: true)
        delegate?.didDelete(model: self)
    }
}

private extension TodoViewModel {

    static func parse(item: ApiTodoItem) -> TodoItem {
        var importance: Importance = .normal
        if let value = Importance(rawValue: item.importance) {
            importance = value
        }
        return TodoItem(
            id: item.id,
            text: item.text,
            importance: importance,
            deadline: item.deadline,
            isFinished: item.isFinished,
            createdAt: item.createdAt,
            changedAt: item.changedAt
        )
    }
}
