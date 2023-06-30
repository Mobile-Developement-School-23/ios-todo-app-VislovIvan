import UIKit

enum Image: String {
    case imagePriorityDown
    case imagePriorityUp
    case imagePlusCircleFill

    case iconStatusOff
    case iconStatusOn
    case iconStatusHighPriority

    case iconArrowRight
    case iconCalendar

    case iconInfo
    case iconTrash
}

extension Image {
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
