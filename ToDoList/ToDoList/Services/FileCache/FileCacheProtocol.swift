import Foundation

protocol FileCacheProtocol {

    func load() throws -> [TodoItem]

    func add(item: TodoItem) throws

    func add(items: [TodoItem]) throws

    func remove(by id: String) throws

    func change(item: TodoItem) throws

    func dropTable() throws
}
