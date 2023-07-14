import Foundation

protocol FileCacheServiceProtocol {

    func add(item: TodoItem) throws

    func remove(by id: String) throws

    func change(item: TodoItem) throws

    func patch(by items: [TodoItem], completion: @escaping (Result<Void, Error>) -> Void)

    func load(
        completion: @escaping (Result<[TodoItem], Error>) -> Void
    )
}
