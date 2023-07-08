import Foundation

final class Variables {

    var revision = 53

    var isInited = false

    var token = "boohooing"

    var isDirty = false

    var isOAuth = false

    static let shared = Variables()

    private init() {}
}
