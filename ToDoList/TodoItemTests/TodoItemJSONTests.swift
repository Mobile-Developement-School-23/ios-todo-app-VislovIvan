import XCTest
@testable import ToDoList

class TodoItemJSONTests: XCTestCase {
    
    let dateExample = Date(timeIntervalSince1970: 1648143750)
    
    func testTodoItemToJSON() {
        let item = TodoItem(id: "1", text: "Todo text", importance: .important, deadline: dateExample, isFinished: true, createdAt: dateExample, changedAt: dateExample)
        let json = item.json as! [String: Any]
        
        XCTAssertEqual(json["id"] as! String, "1")
        XCTAssertEqual(json["text"] as! String, "Todo text")
        XCTAssertEqual(json["importance"] as! String, "important")
        XCTAssertEqual(json["deadline"] as! Double, dateExample.timeIntervalSince1970)
        XCTAssertEqual(json["isFinished"] as! Bool, true)
        XCTAssertEqual(json["createdAt"] as! Double, dateExample.timeIntervalSince1970)
        XCTAssertEqual(json["changedAt"] as! Double, dateExample.timeIntervalSince1970)
    }
    
    func testJSONToTodoItem() {
        let json: [String: Any] = ["id": "1", "text": "Todo text", "importance": "important", "deadline": dateExample.timeIntervalSince1970, "isFinished": true, "createdAt": dateExample.timeIntervalSince1970, "changedAt": dateExample.timeIntervalSince1970]
        let item = TodoItem.parse(json: json)
        
        XCTAssertEqual(item?.id, "1")
        XCTAssertEqual(item?.text, "Todo text")
        XCTAssertEqual(item?.importance, .important)
        XCTAssertEqual(item?.deadline, dateExample)
        XCTAssertEqual(item?.isFinished, true)
        XCTAssertEqual(item?.createdAt, dateExample)
        XCTAssertEqual(item?.changedAt, dateExample)
    }
    
    // Test the same methods for CSV data
    func testTodoItemToCSV() {
        let item = TodoItem(id: "1", text: "Todo text", importance: .important, deadline: dateExample, isFinished: true, createdAt: dateExample, changedAt: dateExample)
        let csv = item.csv
        
        XCTAssertEqual(csv, "1,\"Todo text\",true,\(dateExample.timeIntervalSince1970),important,\(dateExample.timeIntervalSince1970)")
    }
    
    func testCSVToTodoItem() {
        let csv = "1,\"Todo text\",true,\(dateExample.timeIntervalSince1970),important,\(dateExample.timeIntervalSince1970)"
        let item = TodoItem.parse(csv: csv)
        
        XCTAssertEqual(item?.id, "1")
        XCTAssertEqual(item?.text, "Todo text")
        XCTAssertEqual(item?.importance, .important)
        XCTAssertEqual(item?.deadline, dateExample)
        XCTAssertEqual(item?.isFinished, true)
        XCTAssertEqual(item?.createdAt, dateExample)
    }
    
    func testJSONToTodoItemMissingFields() {
        // Missing "id" and "text" fields
        let json: [String: Any] = ["importance": "important", "deadline": dateExample.timeIntervalSince1970, "isFinished": true, "createdAt": dateExample.timeIntervalSince1970, "changedAt": dateExample.timeIntervalSince1970]
        let item = TodoItem.parse(json: json)
        XCTAssertNil(item, "Parsing should fail when required fields are missing")
    }
    
    func testJSONToTodoItemInvalidFieldType() {
        // "isFinished" field is not a boolean
        let json: [String: Any] = ["id": "1", "text": "Todo text", "importance": "important", "deadline": dateExample.timeIntervalSince1970, "isFinished": "not a boolean", "createdAt": dateExample.timeIntervalSince1970, "changedAt": dateExample.timeIntervalSince1970]
        let item = TodoItem.parse(json: json)
        XCTAssertNil(item, "Parsing should fail when a field has an invalid type")
    }
    
    func testJSONToTodoItemInvalidImportanceValue() {
        // "importance" field has an unrecognized value
        let json: [String: Any] = ["id": "1", "text": "Todo text", "importance": "invalid importance", "deadline": dateExample.timeIntervalSince1970, "isFinished": true, "createdAt": dateExample.timeIntervalSince1970, "changedAt": dateExample.timeIntervalSince1970]
        let item = TodoItem.parse(json: json)
        XCTAssertNotNil(item, "Parsing should not fail when 'importance' has an unrecognized value")
        XCTAssertEqual(item?.importance, .normal, "Importance should be set to '.normal' when the value is unrecognized")
    }
    
    func testJSONToTodoItemEmptyJSON() {
        // Empty JSON dictionary
        let json: [String: Any] = [:]
        let item = TodoItem.parse(json: json)
        XCTAssertNil(item, "Parsing should fail when JSON is empty")
    }
    
    func testJSONToTodoItemInvalidJSON() {
        // JSON is not a dictionary
        let json: Any = "invalid JSON"
        let item = TodoItem.parse(json: json)
        XCTAssertNil(item, "Parsing should fail when JSON is not a dictionary")
    }
}
