import Foundation

struct TodoViewState {

    var text: String

    var importance: Importance

    var deadline: Date?

    var isFinished: Bool

    var createdAt: Date = Date()

    var changedAt: Date?

    init(item: TodoItem) {
        text = item.text
        importance = item.importance
        deadline = item.deadline
        isFinished = item.isFinished
        createdAt = item.createdAt
        changedAt = item.changedAt
    }
}
