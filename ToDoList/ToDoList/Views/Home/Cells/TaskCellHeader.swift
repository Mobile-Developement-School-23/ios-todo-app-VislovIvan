import UIKit
import DesignSystem

final class TaskCellHeaderModel {

    var amount: Int = 0
    var action: ((Bool) -> Void)?

    init(amount: Int, action: ((Bool) -> Void)?) {
        self.amount = amount
        self.action = action
    }
}

class TaskCellHeader: UITableViewHeaderFooterView {

    // MARK: - Public properties

    static let identifier: String = "TaskCellHeader"

    var status: Bool = false

    var statusCounter: Int = 0
    
    var model: TaskCellHeaderModel? {
        didSet {
            guard let model = model else { return }
            title.text = "Выполнено задач - \(model.amount)"
        }
    }

    // MARK: - Private properties

    private let title: UILabel = {
        let view = UILabel()
        view.text = "Выполнено - 0"
        view.textColor = Color.labelTertiary.color
        view.font = UIFont.systemFont(ofSize: 15)
        return view
    }()

    private lazy var buttonView: UIButton = {
        let view = UIButton()
        view.setTitle("Скрыть", for: .normal)
        view.setTitleColor(Color.blue.color, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        view.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    // MARK: - Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func setTask(with amount: Int) {
        self.title.text = "Выполнено задач - \(amount)"
    }

    func setButtonTitle(with value: String) {
        self.buttonView.setTitle(value, for: .normal)
    }
    
    func hideActivityIndicator() {
        statusCounter -= 1
        if statusCounter == 0 {
            activityIndicator.stopAnimating()
        }
    }
    
    func showActivityIndicator() {
        statusCounter += 1
        activityIndicator.startAnimating()
    }
}

// MARK: - Private methods

private extension TaskCellHeader {

    func configureContents() {
        [title, buttonView, activityIndicator].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            buttonView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            buttonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            buttonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            activityIndicator.heightAnchor.constraint(equalToConstant: 20),
            activityIndicator.widthAnchor.constraint(equalToConstant: 20),
            activityIndicator.trailingAnchor.constraint(equalTo: buttonView.leadingAnchor, constant: -10),
            activityIndicator.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor)        ])
    }
}

// MARK: - Actions

extension TaskCellHeader {

    @objc func toggle(_ sender: UIButton) {
        model?.action?(status)
        status = !status
    }
}
