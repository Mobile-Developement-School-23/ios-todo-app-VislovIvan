import UIKit

final class ImportanceView: UIView {

    var valueDidChange: ((Importance) -> Void)?

    var importance: Importance? {
        didSet {
            guard let importance = importance else {
                return
            }

            switch importance {
            case .normal:
                segmentedControl.selectedSegmentIndex = 0
            case .unimportant:
                segmentedControl.selectedSegmentIndex = 1
            case .important:
                segmentedControl.selectedSegmentIndex = 2
            }
        }
    }
    
    // MARK: - Private properties
    
    private class Constants {
        static let padding: CGFloat = 16.0
        static let segmentMargin: CGFloat = 9
        static let segmentHeight: CGFloat = 36
        static let fonsize: CGFloat = 17
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Важность"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: Constants.fonsize)
        label.textColor = Color.labelPrimary.color
        return label
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(with: Image.imagePriorityDown.image, at: 0, animated: false)
        sc.insertSegment(withTitle: "нет", at: 1, animated: false)
        sc.insertSegment(withTitle: "‼️", at: 2, animated: false)
        sc.selectedSegmentIndex = 1
        sc.backgroundColor = Color.supportOverlay.color
        sc.selectedSegmentTintColor = Color.backElevated.color

        sc.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        sc.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .touchUpInside)
        return sc
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension ImportanceView {

    func setupViews() {
        [titleLabel, segmentedControl].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),

            segmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: Constants.segmentMargin),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.segmentMargin),
            segmentedControl.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: Constants.segmentHeight)
        ])
    }
}

// MARK: - Action extension

extension ImportanceView {

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            valueDidChange?(Importance.normal)
        case 1:
            valueDidChange?(Importance.unimportant)
        case 2:
            valueDidChange?(Importance.important)
        default:
            valueDidChange?(Importance.normal)
        }
    }
}
