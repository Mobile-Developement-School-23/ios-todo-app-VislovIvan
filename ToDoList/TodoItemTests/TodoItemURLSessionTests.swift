import XCTest
@testable import ToDoList

class TodoItemURLSessionTests: XCTestCase {
    var urlSession: URLSession?
    var url: URL?
    
    override func setUp() {
        super.setUp()
        urlSession = URLSession(configuration: .ephemeral)
        url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")
    }
    
    override func tearDown() {
        urlSession = nil
        url = nil
        super.tearDown()
    }
    
    func testFetchData() async throws {
        guard let urlSession = urlSession,
              let url = url else {
            XCTFail("URL or URLSession is nil")
            return
        }
        
        do {
            let request = URLRequest(url: url)
            let (data, response) = try await urlSession.dataTask(for: request)
            XCTAssertNotNil(data, "No data was downloaded.")
            XCTAssertNotNil(response, "No response received.")
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
}
