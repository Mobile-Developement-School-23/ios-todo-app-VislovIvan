import Foundation

enum Importance: String {
    case normal
    case important
    case unimportant
}

struct TodoItem: Equatable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isFinished: Bool
    let createdAt: Date
    let changedAt: Date?
    let hexColor: String
}

extension TodoItem {
    
    static func parse(json: Any) -> TodoItem? {
        guard let json = json as? [String: Any] else { return nil }
        guard let id = json["id"] as? String,
              let text = json["text"] as? String,
              let isFinished = json["isFinished"] as? Bool,
              let hexColor = json["hexColor"] as? String,
              let startTimeInterval = json["createdAt"] as? Double else { return nil }
        
        let startDate: Date = Date(timeIntervalSince1970: startTimeInterval)
        var importance: Importance = .normal
        var deadline: Date?
        var finishDate: Date?
        
        if let rawValue = json["importance"] as? String, let value = Importance(rawValue: rawValue) {
            importance = value
        }
        
        if let deadlineTimeInterval = json["deadline"] as? Double {
            deadline = Date(timeIntervalSince1970: deadlineTimeInterval)
        }
        
        if let finishTimeInterval = json["changedAt"] as? Double {
            finishDate = Date(timeIntervalSince1970: finishTimeInterval)
        }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isFinished: isFinished,
            createdAt: startDate,
            changedAt: finishDate,
            hexColor: hexColor
        )
    }
    
    var json: Any {
        get {
            var dictionary: [String: Any] = ["id": id,
                                             "text": text,
                                             "isFinished": isFinished,
                                             "hexColor": hexColor,
                                             "createdAt": createdAt.timeIntervalSince1970]
            
            if importance != .normal {
                dictionary["importance"] = importance.rawValue
            }
            
            if let deadline = deadline {
                dictionary["deadline"] = deadline.timeIntervalSince1970
            }
            
            if let changedAt = changedAt {
                dictionary["changedAt"] = changedAt.timeIntervalSince1970
            }
            
            return dictionary
        }
    }
    
    var jsonString: String {
        do {
            let data = try JSONSerialization.data(withJSONObject: self.json)
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            print("JSON Serialization error: \(error)")
            return ""
        }
    }
}

// MARK: - Private methods

private extension TodoItem {
    
    func getPairValue(by elementValue: Any) -> Any? {
        switch elementValue {
        case is String:
            return "\"\(elementValue)\""
        case let date as Date:
            return date.timeIntervalSince1970
        case let isFinished as Bool:
            return isFinished
        case let importance as Importance:
            return importance == Importance.normal ? nil : "\"\(importance)\""
        default:
            return nil
        }
    }
    
    func getData() throws -> Data {
        guard let data = jsonString.data(using: .utf8) else {
            throw NSError()
        }
        return data
    }
}

extension TodoItem {
    
    static func parse(csv: String) -> TodoItem? {
        let values = csv.components(separatedBy: ",")
        
        guard values.count >= 5 else { return nil }
        
        guard let id = values[0] as String?,
              let text = values[1].replacingOccurrences(of: "\"", with: "") as String?,
              let isFinished = Bool(values[2]),
              let hexColor = values[3] as String?,
              let createdAtTimeInterval = Double(values[3]) else { return nil }
        
        let createdAt = Date(timeIntervalSince1970: createdAtTimeInterval)
        
        var importance: Importance = .normal
        if values.count > 4 {
            importance = Importance(rawValue: values[5]) ?? .normal
        }
        
        var deadline: Date?
        if values.count > 6, let deadlineTimeInterval = Double(values[6]) {
            deadline = Date(timeIntervalSince1970: deadlineTimeInterval)
        }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isFinished: isFinished,
            createdAt: createdAt,
            changedAt: nil,
            hexColor: hexColor
        )
    }
    
    var csv: String {
        get {
            var result = "\(id),\"\(text)\",\(isFinished),\(hexColor),\(createdAt.timeIntervalSince1970)"
            
            if importance != .normal {
                result += ",\(importance.rawValue)"
            }
            
            if let deadline = deadline {
                result += ",\(deadline.timeIntervalSince1970)"
            }
            
            return result
        }
    }
}