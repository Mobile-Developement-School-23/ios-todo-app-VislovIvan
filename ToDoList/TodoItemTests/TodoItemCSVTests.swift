import XCTest
@testable import ToDoList

class TodoItemCSVTests: XCTestCase {
    
    func testCsvEncodingDecoding() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = formatter.date(from: "2023/07/01 00:00")
        
        let originalItem = TodoItem(
            id: "TestID",
            text: "Test Text",
            importance: .important,
            deadline: date,
            isFinished: true,
            createdAt: date!,
            changedAt: date,
            hexColor: "#ffffff"
        )
        
        // Convert the original item to CSV
        let csv = originalItem.csv
        
        // Convert CSV back to TodoItem
        let newItem = TodoItem.parse(csv: csv)
        
        // Check if original and new items are the same
        XCTAssertEqual(originalItem, newItem)
    }
}
