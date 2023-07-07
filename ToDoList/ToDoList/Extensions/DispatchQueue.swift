import Foundation

extension DispatchQueue {

    static func main(closure: (() -> Void)) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.sync {
                closure()
            }
        }
    }
}
