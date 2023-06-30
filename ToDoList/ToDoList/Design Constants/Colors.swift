import UIKit

enum Color: String {
    case red
    case green
    case blue
    case gray
    case light
    case white
    case grayLight

    case backiOSPrimary
    case backPrimary
    case backSecondary
    case backElevated

    case labelPrimary
    case labelTertiary
    case labelSecondary
    case labelDisable

    case supportNavBarBlur
    case supportOverlay
    case supportSeparator
}

extension Color {
    var color: UIColor {
        guard let color = UIColor(named: rawValue) else {
            return .black
        }
        return color
    }

    var cgColor: CGColor { color.cgColor }
}
