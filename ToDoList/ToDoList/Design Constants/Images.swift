import UIKit

enum Image: String {
    case imageArrowDown20 = "imagePriorityDown"
    case imageExclaminationPoint20 = "imagePriorityUp"
    case imagePlusCircleFill = "imagePlusCircleFill"
}

extension Image {
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
