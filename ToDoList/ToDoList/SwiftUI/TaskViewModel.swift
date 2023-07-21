import SwiftUI

// можно было использовать старую дату, но скопипастил вот так кривенько
enum ImportanceSwiftUI {
    case unimportant, normal, important
}

struct TodoItemSwiftUI: Identifiable {
    var id = UUID()
    var text: String
    var importance: Importance
    var deadline: Date?
    var isFinished: Bool
    var createdAt: Date?
    var changedAt: Date?
}

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        return formatter
    }()
}
