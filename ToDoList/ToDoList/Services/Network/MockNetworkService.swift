import Foundation

final class MockNetworkService: DefaultNetworkingService {
    
    func get(completion: @escaping (Result<ApiTodoListModel, Error>) -> Void) {}
    func patch(with list: ApiTodoListModel, completion: @escaping (Result<ApiTodoListModel, Error>) -> Void) {}
    func delete(by id: String, completion: @escaping (Result<ApiTodoElementModel, Error>) -> Void) {}
    func update(by element: ApiTodoElementModel, completion: @escaping (Result<ApiTodoElementModel, Error>) -> Void) {}
    func add(by element: ApiTodoElementModel, completion: @escaping (Result<ApiTodoElementModel, Error>) -> Void) {}
    
    func getAllTodoItems(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        let timeout = TimeInterval.random(in: 1..<3)
        DispatchQueue.global().asyncAfter(deadline: .now() + timeout) {
            if Bool.random() {
                completion(.success(self.getStartArray()))
            } else {
                completion(.failure(NetworkError.undefined))
            }
        }
    }

    func editTodoItem(_ item: TodoItem, completion: @escaping (Result<TodoItem, Error>) -> Void) {
        let timeout = TimeInterval.random(in: 1..<3)
        DispatchQueue.global().asyncAfter(deadline: .now() + timeout) {
          completion(.success(item))
        }
    }

    func deleteTodoItem(at id: String, completion: @escaping (Result<TodoItem, Error>) -> Void) {
        let timeout = TimeInterval.random(in: 1..<3)
        DispatchQueue.global().asyncAfter(deadline: .now() + timeout) {
          completion(.success(TodoItem(text: "Hello world")))
        }
    }
}

private extension MockNetworkService {
    
    func getStartArray() -> [TodoItem] {
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
