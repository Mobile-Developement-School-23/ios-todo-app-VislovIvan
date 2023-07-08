import Foundation

final class Debug {

    static let shared = Debug()

    private init() {}

    static func getStartArray() -> [TodoItem] {
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
