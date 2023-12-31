import UIKit
import DesignSystem

final class TaskModel {

    var title: String

    let deadline: IconWithDateModel?

    let radioButton: RadioButtonModel

    init(title: String, deadline: IconWithDateModel?, radioButton: RadioButtonModel) {
        self.title = title
        self.deadline = deadline
        self.radioButton = radioButton
    }
}

final class TaskCell: UITableViewCell {

    var id: String = "templateId"

    // MARK: - Static properties

    static let identifier: String = "TaskTableViewCell"

    var action: (() -> Void)?

    // MARK: - Private properties

    private var highPriorityIconWidthConstraint: NSLayoutConstraint?
    private var lowPriorityIconWidthConstraint: NSLayoutConstraint?
    private var titleLabelLeadingAnchorConstraint: NSLayoutConstraint?

    private let iconWithDateView = IconWithDateView()

    private let radioButtonView = RadioButtonView()

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 3
        return view
    }()

    private let highPriorityIcon: UIImageView = {
        let view = UIImageView(image: Image.imagePriorityUp.image)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let lowPriorityIcon: UIImageView = {
        let view = UIImageView(image: Image.imagePriorityDown.image)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let chevronIcon: UIImageView = {
        let view = UIImageView(image: Image.iconArrowRight.image)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.unstrike()
    }

    // MARK: - Public methods

    func configure(with viewState: TodoViewState) {
        
        if viewState.importance == .important {
            highPriorityIconWidthConstraint?.constant = 10
            titleLabelLeadingAnchorConstraint?.constant = 16
            highPriorityIcon.isHidden = false
        } else if viewState.importance == .normal {
            lowPriorityIconWidthConstraint?.constant = 10
            titleLabelLeadingAnchorConstraint?.constant = 16
            lowPriorityIcon.isHidden = false
        } else {
            highPriorityIconWidthConstraint?.constant = 0
            lowPriorityIconWidthConstraint?.constant = 0
            titleLabelLeadingAnchorConstraint?.constant = 0
        }
        
        if viewState.isFinished {
            highPriorityIconWidthConstraint?.constant = 0
            lowPriorityIconWidthConstraint?.constant = 0
            titleLabelLeadingAnchorConstraint?.constant = 0
        }
        
        titleLabel.text = viewState.text
        
        var status: RadioButtonModel.Status = viewState.importance == .important ? .highPriority : .off
        if viewState.isFinished {
            status = .on
        }
        let radioButtonModel = RadioButtonModel(status: status) { [weak self] in
            self?.action?()
        }
        radioButtonView.configure(with: radioButtonModel)

        iconWithDateView.isHidden = true
        if let deadline = viewState.deadline, radioButtonModel.status != .on {
            let iconWithDateModel = IconWithDateModel(icon: .iconCalendar, date: deadline)
            iconWithDateView.configure(with: iconWithDateModel)
            iconWithDateView.isHidden = false
        }

        if radioButtonModel.status == .on {
            titleLabel.strike()
            iconWithDateView.isHidden = true
        } else {
            titleLabel.unstrike()
        }

        highPriorityIcon.isHidden = viewState.importance != .important
        lowPriorityIcon.isHidden = viewState.importance != .normal
        setNeedsLayout()
    }
}

// MARK: - Private methods

private extension TaskCell {

    func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = Color.backSecondary.color

        [radioButtonView, highPriorityIcon, lowPriorityIcon, chevronIcon, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(iconWithDateView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            radioButtonView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioButtonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            radioButtonView.widthAnchor.constraint(equalToConstant: 24),
            radioButtonView.heightAnchor.constraint(equalToConstant: 24),

            highPriorityIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            highPriorityIcon.leadingAnchor.constraint(equalTo: radioButtonView.trailingAnchor, constant: 16),
                     
            lowPriorityIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lowPriorityIcon.leadingAnchor.constraint(equalTo: radioButtonView.trailingAnchor, constant: 16),

            chevronIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronIcon.widthAnchor.constraint(equalToConstant: 7),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            stackView.trailingAnchor.constraint(equalTo: chevronIcon.leadingAnchor, constant: -16)
        ])

        highPriorityIconWidthConstraint = highPriorityIcon.widthAnchor.constraint(equalToConstant: 10)
        highPriorityIconWidthConstraint?.isActive = true
        
        lowPriorityIconWidthConstraint = lowPriorityIcon.widthAnchor.constraint(equalToConstant: 10)
        lowPriorityIconWidthConstraint?.isActive = true
        
        titleLabelLeadingAnchorConstraint = stackView.leadingAnchor.constraint(equalTo: highPriorityIcon.trailingAnchor, constant: 16)
        titleLabelLeadingAnchorConstraint?.isActive = true
    }
}

// MARK: - Private UILabel extension

private extension UILabel {

    func unstrike() {
        guard let text = self.text else { return }
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        self.attributedText = attributeString
    }

    func strike() {
        guard let text = self.text else { return }
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        self.attributedText = attributeString
    }
}
