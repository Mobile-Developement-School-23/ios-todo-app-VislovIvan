import Foundation

enum DatabaseType {
    case sqlite
    case coreData
}

final class DataStorage {
    var databaseType: DatabaseType = .sqlite {
        didSet {
            switch databaseType {
            case .sqlite:
                fileCache = FileCache(fileName: "yandexDB.sqlite3")
            case .coreData:
                fileCache = CoreDataCache(context: coreDataStack.mainContext)
            }
        }
    }
    
    var fileCache: FileCacheProtocol
    
    private let coreDataStack = CoreDataStack(modelName: "CoreDataService")

    init(databaseType: DatabaseType = .sqlite) {
        switch databaseType {
        case .sqlite:
            fileCache = FileCache(fileName: "yandexDB.sqlite3")
        case .coreData:
            fileCache = CoreDataCache(context: coreDataStack.mainContext)
        }
        
        coreDataStack.loadPersistentStores { error in
            if let error = error {
                print("Error loading CoreData: \(error)")
            }
        }
    }
}
