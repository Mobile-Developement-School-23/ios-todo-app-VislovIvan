import XCTest
@testable import ToDoList

class TodoItemTests: XCTestCase {
    
    func testParseCorrectCSV() {
        let id = "testID"
        let text = "testText"
        let importance = "важная"
        let deadline = "1645678291"
        let isFinished = "true"
        let createdTimestamp = "1645678291"
        let updatedTimestamp = "1645678291"
        let csv = "\(id);\(text);\(importance);\(deadline);\(isFinished);\(createdTimestamp);\(updatedTimestamp)"
        
        let item = TodoItem.parse(csv: csv)
        
        XCTAssertNotNil(item)
        XCTAssertEqual(item?.id, id)
        XCTAssertEqual(item?.text, text)
        XCTAssertEqual(item?.importance.rawValue, importance)
        XCTAssertEqual(item?.deadline?.timeIntervalSince1970, Double(deadline))
        XCTAssertEqual(item?.isFinished, Bool(isFinished))
        XCTAssertEqual(item?.creationDate.timeIntervalSince1970, Double(createdTimestamp))
        XCTAssertEqual(item?.modificationDate?.timeIntervalSince1970, Double(updatedTimestamp))
    }
    
    func testParseIncorrectCSV() {
        let csv = "incorrectCSVString"
        
        let item = TodoItem.parse(csv: csv)
        
        XCTAssertNil(item)
    }
    
    func testCSVValue() {
        let id = "testID"
        let text = "testText"
        let importance = Importance.important
        let deadline = Date(timeIntervalSince1970: 1645678291)
        let isFinished = true
        let createdTimestamp = Date(timeIntervalSince1970: 1645678291)
        let updatedTimestamp = Date(timeIntervalSince1970: 1645678291)
        
        let item = TodoItem(id: id, text: text, importance: importance, deadline: deadline, isFinished: isFinished, creationDate: createdTimestamp, modificationDate: updatedTimestamp)
        let expectedCSV = "\(id);\(text);\(importance.rawValue);\(Int(deadline.timeIntervalSince1970));\(isFinished);\(Int(createdTimestamp.timeIntervalSince1970));\(Int(updatedTimestamp.timeIntervalSince1970))"
        
        XCTAssertEqual(item.csv, expectedCSV)
    }
    
    func testParsePartialCSV() {
        let id = "testID"
        let text = "testText"
        let importance = "важная"
        let isFinished = "true"
        let createdTimestamp = "1645678291"
        let csv = "\(id);\(text);\(importance);;\(isFinished);\(createdTimestamp)"
        
        let item = TodoItem.parse(csv: csv)
        
        XCTAssertNotNil(item)
        XCTAssertEqual(item?.id, id)
        XCTAssertEqual(item?.text, text)
        XCTAssertEqual(item?.importance.rawValue, importance)
        XCTAssertNil(item?.deadline)
        XCTAssertEqual(item?.isFinished, Bool(isFinished))
        XCTAssertEqual(item?.creationDate.timeIntervalSince1970, Double(createdTimestamp))
        XCTAssertNil(item?.modificationDate)
    }
    
    func testParseIncorrectDataCSV() {
        let id = "testID"
        let text = "testText"
        let importance = "важная"
        let deadline = "notANumber"
        let isFinished = "true"
        let createdTimestamp = "alsoNotANumber"
        let csv = "\(id);\(text);\(importance);\(deadline);\(isFinished);\(createdTimestamp)"
        
        let item = TodoItem.parse(csv: csv)
        
        XCTAssertNotNil(item)
        XCTAssertEqual(item?.id, id)
        XCTAssertEqual(item?.text, text)
        XCTAssertEqual(item?.importance.rawValue, importance)
        XCTAssertNil(item?.deadline)
        XCTAssertEqual(item?.isFinished, Bool(isFinished))
        XCTAssertNotEqual(item?.creationDate.timeIntervalSince1970, Date().timeIntervalSince1970)
    }
    
    func testPartialCSVValue() {
        let id = "testID"
        let text = "testText"
        let importance = Importance.important
        let isFinished = true
        let createdTimestamp = Date(timeIntervalSince1970: 1645678291)
        
        let item = TodoItem(id: id, text: text, importance: importance, deadline: nil, isFinished: isFinished, creationDate: createdTimestamp, modificationDate: nil)
        let expectedCSV = "\(id);\(text);\(importance.rawValue);;\(isFinished);\(Int(createdTimestamp.timeIntervalSince1970))"
        
        XCTAssertEqual(item.csv, expectedCSV)
    }
}
