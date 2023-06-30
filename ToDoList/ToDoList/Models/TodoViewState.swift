import Foundation

/// Модель задачи
struct TodoViewState {

    /// Содержание задачи
    var text: String

    /// Важность задачи
    var importance: Importance

    /// Дедлайн
    var deadline: Date?

    /// Статус завершения задачи
    var isFinished: Bool

    /// Дата начала выполнения задачи
    var createdAt: Date = Date()

    /// Дата окончания задачи
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
