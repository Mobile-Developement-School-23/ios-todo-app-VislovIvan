import Foundation

enum NetworkError: Error {
    case invalidJson
    case undefined
}

protocol NetworkServiceProtocol {

    func getAllTodoItems(
        completion: @escaping (Result<[TodoItem], Error>) -> Void
    )

    func editTodoItem(
        _ item: TodoItem,
        completion: @escaping (Result<TodoItem, Error>) -> Void
    )

    func deleteTodoItem(
        at id: String,
        completion: @escaping (Result<TodoItem, Error>) -> Void
    )
}
