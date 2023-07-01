import UIKit
import DesignSystem

// MARK: - IconWithDateModel model

final class IconWithDateModel {

    var icon: Image

    var date: Date

    init(icon: Image, date: Date) {
        self.icon = icon
        self.date = date
    }
}

final class IconWithDateView: UIStackView {

    private class Constants {
        static let fontsize: CGFloat = 16.0
    }

    let iconView: UIImageView = {
        let view = UIImageView()
        view.tintColor = Color.labelTertiary.color
        return view
    }()

    let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.textColor = Color.labelTertiary.color
        view.font = UIFont.systemFont(ofSize: Constants.fontsize)
        return view
    }()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: IconWithDateModel) {
        iconView.image = model.icon.image

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        titleLabel.text = dateFormatter.string(from: model.date)
    }
}

// MARK: - IconWithDateView extension

private extension IconWithDateView {

    func setupViews() {
        axis = .horizontal
        distribution = .equalSpacing
        spacing = 4
        alignment = .center

        addArrangedSubview(iconView)
        addArrangedSubview(titleLabel)
    }
}
