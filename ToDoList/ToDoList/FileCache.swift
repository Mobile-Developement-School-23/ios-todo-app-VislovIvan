import Foundation

// MARK: - FileCache Class

class FileCache {
    var itemsDictionary: [String: TodoItem] = [:]
    
    // Свойство для предоставления всех элементов в форме массива
    public var items: [TodoItem] {
        return Array(itemsDictionary.values)
    }
    
    private let fileManager: FileManager
    private let documentsURL: URL?

    init() {
        fileManager = FileManager.default
        documentsURL = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
    
    // MARK: - Add New Item
    
    func add(item: TodoItem) {
        itemsDictionary[item.id] = item
    }
    
    // MARK: - Remove an Item
    
    func remove(itemId: String) {
        itemsDictionary.removeValue(forKey: itemId)
    }
    
    // MARK: - Save Items to JSON File
    
    func saveItemsToFile(withName fileName: String) {
        guard let documentsURL = documentsURL else {
            print("Could not get the documents directory url.")
            return
        }

        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        let itemsArray = items
        let jsonArray = itemsArray.map { $0.json }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: [])
            if fileManager.createFile(atPath: fileURL.path, contents: jsonData, attributes: nil) {
                print("File \(fileName) was created and items were saved successfully.")
            } else {
                print("There was an error creating the file \(fileName).")
            }
        } catch {
            print("There was an error saving items to file \(fileName): \(error.localizedDescription)")
        }
    }
    
    // MARK: - Function to Load Items from JSON File
    
    func loadItemsFromFile(withName fileName: String) {
        guard let documentsURL = documentsURL else {
            print("Could not get the documents directory url.")
            return
        }

        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                itemsDictionary = [:]
                for itemDict in jsonArray {
                    if let todoItem = TodoItem.parse(json: itemDict) {
                        itemsDictionary[todoItem.id] = todoItem
                    }
                }
                print("Items were loaded from file \(fileName) successfully.")
            } else {
                print("There was an error parsing items from file \(fileName).")
            }
        } catch {
            print("There was an error loading items from file \(fileName): \(error.localizedDescription)")
        }
    }
}

extension FileCache {

    // MARK: - Save Items to CSV File

    func saveItemsToCSVFile(withName fileName: String) {
        guard let documentsURL = documentsURL else {
            print("Could not get the documents directory url.")
            return
        }

        let fileURL = documentsURL.appendingPathComponent(fileName)

        let itemsArray = items
        let csvArray = itemsArray.map { $0.csv }
        let csvData = csvArray.joined(separator: "\n").data(using: .utf8)

        do {
            try csvData?.write(to: fileURL)
            print("File \(fileName) was created and items were saved successfully.")
        } catch {
            print("There was an error saving items to file \(fileName): \(error.localizedDescription)")
        }
    }

    // MARK: - Load Items from CSV File

    func loadItemsFromCSVFile(withName fileName: String) {
        guard let documentsURL = documentsURL else {
            print("Could not get the documents directory url.")
            return
        }

        let fileURL = documentsURL.appendingPathComponent(fileName)

        do {
            let csvData = try String(contentsOf: fileURL, encoding: .utf8)
            let csvArray = csvData.components(separatedBy: "\n")

            itemsDictionary = [:]
            for csvString in csvArray {
                if let todoItem = TodoItem.parse(csv: csvString) {
                    itemsDictionary[todoItem.id] = todoItem
                }
            }
            print("Items were loaded from file \(fileName) successfully.")
        } catch {
            print("There was an error loading items from file \(fileName): \(error.localizedDescription)")
        }
    }
}
