import CoreData

struct CoreDataStack {
    let persistentContainer: NSPersistentContainer

    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func loadPersistentStores(completion: @escaping (Error?) -> ()) {
        persistentContainer.loadPersistentStores { _, error in
            completion(error)
        }
    }

    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}
