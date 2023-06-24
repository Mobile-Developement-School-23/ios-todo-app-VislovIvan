import UIKit

final class DeadlineView: UIView {

    // MARK: - Public properties

    var valueDidChange: ((Bool) -> Void)?

    var deadLineDidClicked: (() -> Void)?

    var deadline: Date? {
        didSet {
            guard let deadline = deadline else {
                UIView.animate(withDuration: 0.25, delay: 0, animations: { [weak self] in
                    self?.subTitleLabel.text = ""
                    self?.subTitleLabel.isHidden = true
                    self?.subTitleLabel.layer.opacity = 0
                })
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM YYYY"

            subTitleLabel.text = dateFormatter.string(from: deadline)

            UIView.animate(withDuration: 0.25, delay: 0, animations: { [weak self] in
                self?.subTitleLabel.isHidden = false
                self?.subTitleLabel.layer.opacity = 1
            })

            toggleButton.setOn(true, animated: false)
        }
    }

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сделать до"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = Color.labelPrimary.color
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = Color.blue.color
        return label
    }()

    private lazy var toggleButton: UISwitch = {
        let button = UISwitch()
        button.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        button.backgroundColor = Color.supportOverlay.color
        button.layer.cornerRadius = button.frame.height / 2.0
        return button
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()

        let tap = UITapGestureRecognizer(target: self, action: #selector(clickTitleLabel))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private extension

private extension DeadlineView {

    func setupViews() {
        [stackView, toggleButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 9),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            toggleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            toggleButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - Actions extension

extension DeadlineView {

    @objc func valueChanged(switcher: UISwitch) {
        valueDidChange?(switcher.isOn)
    }

    @objc func clickTitleLabel(sender:UITapGestureRecognizer) {
        deadLineDidClicked?()
    }
}
