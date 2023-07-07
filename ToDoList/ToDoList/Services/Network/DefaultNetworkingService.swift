import Foundation

enum NetworkError: Error {
    case invalidJson
    case undefined
}

protocol DefaultNetworkingService {

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
    
    // MARK: - Public working methods
    
        func get(completion: @escaping (Result<ApiTodoListModel, Error>) -> Void)

        func patch(
            with list: ApiTodoListModel,
            completion: @escaping (Result<ApiTodoListModel, Error>) -> Void
        )

        func delete(
            by id: String,
            completion: @escaping (Result<ApiTodoElementModel, Error>) -> Void
        )

        func update(
            by element: ApiTodoElementModel,
            completion: @escaping (Result<ApiTodoElementModel, Error>) -> Void
        )

        func add(
            by element: ApiTodoElementModel,
            completion: @escaping (Result<ApiTodoElementModel, Error>) -> Void
        )
}
