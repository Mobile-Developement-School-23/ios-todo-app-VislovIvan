import Foundation

enum FileCacheError: Error {
    case invalidJson
    case noDocumentDirectory
    case itemAlreadyExist
}
