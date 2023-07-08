import Foundation

protocol FileCacheServiceProtocol {

    var items: [TodoItem] { get }

    func add(item: TodoItem) throws

    func removeItem(by id: String) throws

    func get(by id: String) -> TodoItem?

    func change(item: TodoItem) throws

    func save(
        to file: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )

    func load(
        from file: String,
        completion: @escaping (Result<[TodoItem], Error>) -> Void
    )
}
