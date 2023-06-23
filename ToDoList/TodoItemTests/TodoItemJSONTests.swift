import XCTest
@testable import ToDoList

class TodoItemTests: XCTestCase {
    
    func testJSONParseAndSerialization() {
        let initialId = UUID().uuidString
        let initialText = "test text"
        let initialImportance = Importance.important
        let initialDeadline = Date()
        let initialIsFinished = true
        let initialCreationDate = Date()
        let initialModificationDate = Date()
        
        let initialTodoItem = TodoItem(
            id: initialId,
            text: initialText,
            importance: initialImportance,
            deadline: initialDeadline,
            isFinished: initialIsFinished,
            creationDate: initialCreationDate,
            modificationDate: initialModificationDate
        )
        
        // Convert TodoItem to JSON
        guard let jsonData = try? JSONSerialization.data(withJSONObject: initialTodoItem.json, options: []) else {
            XCTFail("Failed to serialize TodoItem into JSON.")
            return
        }
        
        // Parse JSON to TodoItem
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []),
              let parsedTodoItem = TodoItem.parse(json: json) else {
            XCTFail("Failed to parse JSON into TodoItem.")
            return
        }
        
        XCTAssertEqual(initialId, parsedTodoItem.id)
        XCTAssertEqual(initialText, parsedTodoItem.text)
        XCTAssertEqual(initialImportance, parsedTodoItem.importance)
        XCTAssertEqual(initialIsFinished, parsedTodoItem.isFinished)
        
        XCTAssertEqual(Int(initialDeadline.timeIntervalSince1970), Int(parsedTodoItem.deadline?.timeIntervalSince1970 ?? 0))
        XCTAssertEqual(Int(initialCreationDate.timeIntervalSince1970), Int(parsedTodoItem.creationDate.timeIntervalSince1970))
        XCTAssertEqual(Int(initialModificationDate.timeIntervalSince1970), Int(parsedTodoItem.modificationDate?.timeIntervalSince1970 ?? 0))
    }
    
    func testJSONParseMissingRequiredFields() {
        let json: [String: Any] = [
            "id": UUID().uuidString,
            "text": "test text",
            "importance": Importance.important.rawValue,
            "deadline": Date().timeIntervalSince1970,
            "creationDate": Date().timeIntervalSince1970,
            "modificationDate": Date().timeIntervalSince1970
        ]
        
        let parsedTodoItem = TodoItem.parse(json: json)
        XCTAssertNil(parsedTodoItem, "Parsing should fail if any of the required fields are missing.")
    }
    
    // Testing JSON parsing with incorrect field types
    func testJSONParseIncorrectFieldTypes() {
        let json: [String: Any] = [
            "id": 123,
            "text": "test text",
            "importance": Importance.important.rawValue,
            "deadline": Date().timeIntervalSince1970,
            "isFinished": true,
            "creationDate": Date().timeIntervalSince1970,
            "modificationDate": Date().timeIntervalSince1970
        ]
        
        let parsedTodoItem = TodoItem.parse(json: json)
        XCTAssertNil(parsedTodoItem, "Parsing should fail if any of the fields have incorrect types.")
    }
    
    // Testing JSON parsing with invalid Importance value
    func testJSONParseInvalidImportance() {
        let json: [String: Any] = [
            "id": UUID().uuidString,
            "text": "test text",
            "importance": "invalidImportance",
            "deadline": Date().timeIntervalSince1970,
            "isFinished": true,
            "creationDate": Date().timeIntervalSince1970,
            "modificationDate": Date().timeIntervalSince1970
        ]
        
        guard let parsedTodoItem = TodoItem.parse(json: json) else {
            XCTFail("Parsing failed.")
            return
        }
        
        XCTAssertEqual(parsedTodoItem.importance, .normal, "Importance should be '.normal' when given invalid value.")
    }
    
    // Testing JSON serialization
    func testJSONSerialization() {
        let todoItem = TodoItem(
            id: UUID().uuidString,
            text: "test text",
            importance: .important,
            deadline: Date(),
            isFinished: true,
            creationDate: Date(),
            modificationDate: Date()
        )
        
        guard let json = todoItem.json as? [String: Any] else {
            XCTFail("Failed to convert TodoItem to JSON.")
            return
        }
        
        XCTAssertTrue(json.keys.contains("id"))
        XCTAssertTrue(json.keys.contains("text"))
        XCTAssertTrue(json.keys.contains("importance"))
        XCTAssertTrue(json.keys.contains("deadline"))
        XCTAssertTrue(json.keys.contains("isFinished"))
        XCTAssertTrue(json.keys.contains("creationDate"))
        XCTAssertTrue(json.keys.contains("modificationDate"))
    }
}
