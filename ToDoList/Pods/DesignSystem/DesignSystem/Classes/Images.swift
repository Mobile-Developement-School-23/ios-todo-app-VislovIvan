import UIKit

public enum Image: String {
    case imagePriorityDown = "imagePriorityDown"
    case imagePriorityUp = "imagePriorityUp"
    case imagePlusCircleFill = "imagePlusCircleFill"
    
    case iconStatusOff = "iconStatusOff"
    case iconStatusOn = "iconStatusOn"
    case iconStatusHighPriority = "iconStatusHighPriority"

    case iconArrowRight = "iconArrowRight"
    case iconCalendar = "iconCalendar"

    case iconInfo = "iconInfo"
    case iconTrash = "iconTrash"
}

public extension Image {
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
