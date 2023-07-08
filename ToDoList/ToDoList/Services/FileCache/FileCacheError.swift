import Foundation

enum FileCacheError: Error {
    case invalidJson
    case noDocumentDirectory
    case itemAlreadyExist
    case undefined
}

enum HomeViewModelError: Error {
    case suchIdDoesntExist
}
