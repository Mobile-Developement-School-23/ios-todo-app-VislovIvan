import CoreData

final class CoreDataCache: FileCacheProtocol {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func load() throws -> [TodoItem] {
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        let entities = try context.fetch(request)
        return entities.compactMap { TodoItem(from: $0) }
    }

    func add(item: TodoItem) throws {
        let entity = TodoItemEntity(context: context)
        entity.configure(from: item)
        try context.save()
    }

    func add(items: [TodoItem]) throws {
        for item in items {
            let entity = TodoItemEntity(context: context)
            entity.configure(from: item)
        }
        try context.save()
    }

    func remove(by id: String) throws {
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        let entities = try context.fetch(request)
        for entity in entities {
            context.delete(entity)
        }
        try context.save()
    }

    func change(item: TodoItem) throws {
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", item.id)
        let entities = try context.fetch(request)
        if let entity = entities.first {
            entity.configure(from: item)
            try context.save()
        }
    }

    func dropTable() throws {
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        let entities = try context.fetch(request)
        for entity in entities {
            context.delete(entity)
        }
        try context.save()
    }
}
