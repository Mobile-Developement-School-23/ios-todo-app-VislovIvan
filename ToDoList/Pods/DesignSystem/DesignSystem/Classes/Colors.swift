import UIKit

public enum Color: String {
    case red = "red"
    case green = "green"
    case blue = "blue"
    case gray = "gray"
    case light = "light"
    case white = "white"
    case grayLight = "grayLight"

    case backiOSPrimary = "backiOSPrimary"
    case backPrimary = "backPrimary"
    case backSecondary = "backSecondary"
    case backElevated = "backElevated"

    case labelPrimary = "labelPrimary"
    case labelTertiary = "labelTertiary"
    case labelSecondary = "labelSecondary"
    case labelDisable = "labelDisable"

    case supportNavBarBlur = "supportNavBarBlur"
    case supportOverlay = "supportOverlay"
    case supportSeparator = "supportSeparator"
}

public extension Color {
    var color: UIColor {
        guard let color = UIColor(named: rawValue) else {
            return .black
        }
        return color
    }

    var cgColor: CGColor { color.cgColor }
}
