import XCTest
@testable import ToDoList

class TodoItemCSVTests: XCTestCase {
    
    func testTodoItemToCSVConversion() {
        let id = "1"
        let text = "Test task"
        let importance = Importance.normal
        let isFinished = false
        let createdAt = Date(timeIntervalSince1970: 1624476032)
        let todoItem = TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: nil,
            isFinished: isFinished,
            createdAt: createdAt,
            changedAt: nil
        )

        let csv = todoItem.csv
        let expectedCSV = "\(id),\"\(text)\",\(isFinished),\(createdAt.timeIntervalSince1970)"
        XCTAssertEqual(csv, expectedCSV)
    }

    func testCSVToTodoItemConversion() {
        let id = "1"
        let text = "Test task"
        let importance = "normal"
        let isFinished = false
        let createdAtTimeInterval = 1624476032.0
        let createdAt = Date(timeIntervalSince1970: createdAtTimeInterval)

        let csv = "\(id),\"\(text)\",\(isFinished),\(createdAtTimeInterval)"
        let todoItem = TodoItem.parse(csv: csv)

        XCTAssertNotNil(todoItem)
        XCTAssertEqual(todoItem?.id, id)
        XCTAssertEqual(todoItem?.text, text)
        XCTAssertEqual(todoItem?.importance.rawValue, importance)
        XCTAssertEqual(todoItem?.isFinished, isFinished)
        XCTAssertEqual(todoItem?.createdAt, createdAt)
        XCTAssertNil(todoItem?.deadline)
        XCTAssertNil(todoItem?.changedAt)
    }
}
