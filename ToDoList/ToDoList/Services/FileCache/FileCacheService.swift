import Foundation

final class FileCacheService {

    // MARK: - Private properties

    private let fileName: String

    private lazy var fileCache: FileCacheProtocol = FileCache(fileName: fileName)

    // MARK: - Queues

    private let globalQueue = DispatchQueue(label: "filecacheQueue", attributes: .concurrent)

    init(fileName: String = "develop.json") {
        self.fileName = fileName
    }
}

extension FileCacheService: FileCacheServiceProtocol {

    func change(item: TodoItem) throws {
        try fileCache.change(item: item)
    }

    func add(item: TodoItem) throws {
        try fileCache.add(item: item)
    }

    func remove(by id: String) throws {
        try fileCache.remove(by: id)
    }

    func patch(by items: [TodoItem], completion: @escaping (Result<Void, Error>) -> Void) {
        globalQueue.async(flags: .barrier) { [weak self] in
            do {
                try self?.fileCache.dropTable()
                try self?.fileCache.add(items: items)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func load(completion: @escaping (Result<[TodoItem], Error>) -> Void) {
        globalQueue.async(flags: .barrier) { [weak self] in
            do {
                guard let items = try self?.fileCache.load() else {
                    throw FileCacheError.undefined
                }
                DispatchQueue.main.async {
                    completion(.success(items))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
