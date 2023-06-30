import UIKit

final class RadioButtonModel {

    /// Статус кнопки
    var status: Status

    /// Действие, необходимое для совершения при клике по кнопке
    var action: (() -> Void)?

    /// Инициализатор
    /// - Parameters:
    ///   - status: Статус кнопки
    ///   - model: Изменяемый объект
    ///   - action: Действие, необходимое для совершения при клике по кнопке
    init(status: Status, action: (() -> Void)?) {
        self.status = status
        self.action = action
    }
}

extension RadioButtonModel {

    /// Состояние кнопки
    enum Status {
        case on
        case off
        case highPriority
    }
}

final class RadioButtonView: UIButton {

    var model: RadioButtonModel?

    let iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = Color.supportSeparator.color
        return view
    }()

    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()

        addTarget(self, action: #selector(radioButtonDidClicked), for: .touchUpInside)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: RadioButtonModel) {
        self.model = model

        switch model.status {
        case .on:
            iconView.image = Image.iconStatusOn.image
        case .off:
            iconView.image = Image.iconStatusOff.image
            iconView.tintColor = Color.labelTertiary.color
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        case .highPriority:
            iconView.image = Image.iconStatusHighPriority.image
        }
    }
}

private extension RadioButtonView {

    func setupViews() {
        addSubview(iconView)
    }

    func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}


// MARK: - Actions

extension RadioButtonView {

    @objc func radioButtonDidClicked(sender: UIButton) {
        model?.action?()
    }
}
