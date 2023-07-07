import Foundation

final class NetworkService {

}

extension NetworkService: NetworkServiceProtocol {

    func getAllTodoItems(completion: @escaping (Result<[TodoItem], Error>) -> Void) {

    }

    func editTodoItem(_ item: TodoItem, completion: @escaping (Result<TodoItem, Error>) -> Void) {

    }

    func deleteTodoItem(at id: String, completion: @escaping (Result<TodoItem, Error>) -> Void) {

    }
}
