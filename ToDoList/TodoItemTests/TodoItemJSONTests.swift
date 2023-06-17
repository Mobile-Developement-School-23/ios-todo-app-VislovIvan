import XCTest
@testable import ToDoList

class TodoItemJSONTests: XCTestCase {
    
    func testDecodeTodoItemFromJSON() {
        let json = """
        {
            "id": "testID",
            "text": "testText",
            "importance": "важная",
            "deadline": 1645678291,
            "isFinished": true,
            "creationDate": 1645678291,
            "modificationDate": 1645678291
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        do {
            let item = try decoder.decode(TodoItem.self, from: json)
            
            XCTAssertEqual(item.id, "testID")
            XCTAssertEqual(item.text, "testText")
            XCTAssertEqual(item.importance, .important)
            XCTAssertEqual(item.deadline?.timeIntervalSince1970, 1645678291)
            XCTAssertEqual(item.isFinished, true)
            XCTAssertEqual(item.creationDate.timeIntervalSince1970, 1645678291)
            XCTAssertEqual(item.modificationDate?.timeIntervalSince1970, 1645678291)
        } catch {
            XCTFail("Failed to decode TodoItem from JSON: \(error)")
        }
    }
    
    func testEncodeTodoItemToJSON() {
        let item = TodoItem(
            id: "testID",
            text: "testText",
            importance: .important,
            deadline: Date(timeIntervalSince1970: 1645678291),
            isFinished: true,
            creationDate: Date(timeIntervalSince1970: 1645678291),
            modificationDate: Date(timeIntervalSince1970: 1645678291)
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        
        do {
            let jsonData = try encoder.encode(item)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            
            XCTAssertEqual(jsonObject?["id"] as? String, "testID")
            XCTAssertEqual(jsonObject?["text"] as? String, "testText")
            XCTAssertEqual(jsonObject?["importance"] as? String, "важная")
            XCTAssertEqual(jsonObject?["deadline"] as? Double, 1645678291)
            XCTAssertEqual(jsonObject?["isFinished"] as? Bool, true)
            XCTAssertEqual(jsonObject?["creationDate"] as? Double, 1645678291)
            XCTAssertEqual(jsonObject?["modificationDate"] as? Double, 1645678291)
        } catch {
            XCTFail("Failed to encode TodoItem to JSON: \(error)")
        }
    }
    
    func testEncodePartialTodoItemToJSON() {
        let item = TodoItem(
            id: "testID",
            text: "testText",
            importance: .important,
            deadline: nil,
            isFinished: true,
            creationDate: Date(timeIntervalSince1970: 1645678291),
            modificationDate: nil
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        
        do {
            let jsonData = try encoder.encode(item)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            
            XCTAssertEqual(jsonObject?["id"] as? String, "testID")
            XCTAssertEqual(jsonObject?["text"] as? String, "testText")
            XCTAssertEqual(jsonObject?["importance"] as? String, "важная")
            XCTAssertNil(jsonObject?["deadline"])
            XCTAssertEqual(jsonObject?["isFinished"] as? Bool, true)
            XCTAssertEqual(jsonObject?["creationDate"] as? Double, 1645678291)
            XCTAssertNil(jsonObject?["modificationDate"])
        } catch {
            XCTFail("Failed to encode TodoItem to JSON: \(error)")
        }
    }
    
    func testDecodePartialJSON() {
        let json = """
           {
               "id": "testID",
               "text": "testText",
               "importance": "важная",
               "isFinished": true,
               "creationDate": 1645678291
           }
           """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        do {
            let item = try decoder.decode(TodoItem.self, from: json)
            
            XCTAssertEqual(item.id, "testID")
            XCTAssertEqual(item.text, "testText")
            XCTAssertEqual(item.importance, .important)
            XCTAssertNil(item.deadline)
            XCTAssertEqual(item.isFinished, true)
            XCTAssertEqual(item.creationDate.timeIntervalSince1970, 1645678291)
            XCTAssertNil(item.modificationDate)
        } catch {
            XCTFail("Failed to decode TodoItem from JSON: \(error)")
        }
    }
    
    func testDecodeIncorrectDataJSON() {
        let json = """
           {
               "id": 123,
               "text": 456,
               "importance": "важная",
               "deadline": "notANumber",
               "isFinished": "true",
               "creationDate": "alsoNotANumber",
               "modificationDate": 789
           }
           """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        do {
            let item = try decoder.decode(TodoItem.self, from: json)
            XCTAssertNil(item, "TodoItem should not be created from incorrect data")
        } catch {}
    }
}
