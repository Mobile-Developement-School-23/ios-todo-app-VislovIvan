import Foundation

protocol FileCacheProtocol {

    var items: [TodoItem] { get }

    func saveItems(to file: String) throws

    func loadItems(from file: String) throws

    func add(item: TodoItem) throws

    func removeItem(by id: String) throws

    func get(by id: String) -> TodoItem?

    func change(item: TodoItem) throws
}
