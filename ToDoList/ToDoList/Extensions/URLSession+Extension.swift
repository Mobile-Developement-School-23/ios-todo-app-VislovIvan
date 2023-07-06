import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        var urlSessionDataTask: URLSessionDataTask?

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                urlSessionDataTask = self.dataTask(with: urlRequest) { (data, response, error) in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    } else {
                        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
                        continuation.resume(throwing: error)
                    }
                }
                urlSessionDataTask?.resume()
            }
        } onCancel: { [weak urlSessionDataTask] in
            urlSessionDataTask?.cancel()
        }
    }
}
