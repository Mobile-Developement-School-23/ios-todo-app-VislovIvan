import Foundation

// MARK: - TodoItem Structure

enum Importance: String {
    case unimportant = "неважная"
    case normal = "обычная"
    case important = "важная"
}

struct TodoItem {

    // TodoItem Properties
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isFinished: Bool
    let creationDate: Date
    let modificationDate: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isFinished: Bool = false,
        creationDate: Date = Date(),
        modificationDate: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isFinished = isFinished
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }
}

// MARK: - TodoItem JSON Parsing

extension TodoItem {
    
    // Function to Parse TodoItem from JSON
    static func parse(json: Any) -> TodoItem? {
        guard let dictionary = json as? [String: Any] else { return nil }
        
        guard let id = dictionary["id"] as? String else { return nil }
        guard let text = dictionary["text"] as? String else { return nil }
        let importance = dictionary["importance"] as? String
        guard let isFinished = dictionary["isFinished"] as? Bool else { return nil }
        guard let creationDateTimeInterval = dictionary["creationDate"] as? Double else { return nil }
        
        let creationDate = Date(timeIntervalSince1970: creationDateTimeInterval)
        let importanceEnum = Importance(rawValue: importance ?? "") ?? .normal
        var deadline: Date?
        var modificationDate: Date?

        if let deadlineTimeInterval = dictionary["deadline"] as? Double {
            deadline = Date(timeIntervalSince1970: deadlineTimeInterval)
        }
        
        if let modificationDateTimeInterval = dictionary["modificationDate"] as? Double {
            modificationDate = Date(timeIntervalSince1970: modificationDateTimeInterval)
        }
        
        return TodoItem(
            id: id, text: text,
            importance: importanceEnum,
            deadline: deadline,
            isFinished: isFinished,
            creationDate: creationDate,
            modificationDate: modificationDate
        )
    }
    
    // Property to Convert TodoItem to JSON
    var json: Any {
        var dictionary: [String: Any] = [
            "id": id,
            "text": text,
            "isFinished": isFinished,
            "creationDate": creationDate.timeIntervalSince1970
        ]
        
        if importance != .normal {
            dictionary["importance"] = importance.rawValue
        }
        
        if let deadline = deadline {
            dictionary["deadline"] = deadline.timeIntervalSince1970
        }
        
        if let modificationDate = modificationDate {
            dictionary["modificationDate"] = modificationDate.timeIntervalSince1970
        }
        
        return dictionary
    }
}

// MARK: - CSV Parsing

extension TodoItem {

    static func parse(csv: String) -> TodoItem? {
        let components = csv.components(separatedBy: ";")
        
        guard components.count >= 6 else { return nil }

        let id = components[0].isEmpty ? UUID().uuidString : components[0]
        let text = components[1]
        let importanceRawValue = components[2]
        let importance = Importance(rawValue: importanceRawValue) ?? .normal

        var deadline: Date?
        if let deadlineDouble = Double(components[3]) {
            deadline = Date(timeIntervalSince1970: deadlineDouble)
        }

        let isFinished = Bool(components[4]) ?? false

        var createdTimestamp = Date()
        if let createdTimestampDouble = Double(components[5]) {
            createdTimestamp = Date(timeIntervalSince1970: createdTimestampDouble)
        }

        var updatedTimestamp: Date?
        if components.count >= 7, let updatedTimestampDouble = Double(components[6]) {
            updatedTimestamp = Date(timeIntervalSince1970: updatedTimestampDouble)
        }

        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isFinished: isFinished,
            creationDate: createdTimestamp,
            modificationDate: updatedTimestamp
        )
    }

    var csv: String {
        var components: [String] = []
        
        components.append(id)
        components.append(text)
        components.append(importance == .normal ? "" : importance.rawValue)
        
        if let deadline = deadline {
            components.append("\(Int(deadline.timeIntervalSince1970))")
        } else {
            components.append("")
        }
        
        components.append("\(isFinished)")
        components.append("\(Int(creationDate.timeIntervalSince1970))")
        
        if let modificationDate = modificationDate {
            components.append("\(Int(modificationDate.timeIntervalSince1970))")
        }
        
        return components.joined(separator: ";")
    }
}
