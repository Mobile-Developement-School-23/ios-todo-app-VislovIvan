import XCTest
@testable import ToDoList

class TodoItemJSONTests: XCTestCase {
    
    func testJsonEncodingDecoding() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = formatter.date(from: "2023/07/01 00:00")
        
        let originalItem = TodoItem(
            id: "TestID",
            text: "Test Text",
            importance: .important,
            deadline: date,
            isFinished: true,
            createdAt: date,
            changedAt: date,
            hexColor: "#ffffff"
        )
        
        let json = originalItem.json
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
        let newItem = TodoItem.parse(json: jsonObject)
        
        XCTAssertEqual(originalItem, newItem)
    }
    
    func testTodoItemToggleComplete() {
        let originalItem = TodoItem(text: "Test Text")
        
        let toggledItem = originalItem.toggleComplete()
        
        XCTAssertTrue(toggledItem.isFinished)
        XCTAssertFalse(originalItem.isFinished)
    }
}
