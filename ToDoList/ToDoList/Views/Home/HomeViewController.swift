import UIKit

final class HomeViewController: UIViewController {
    
    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.imagePlusCircleFill.image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 16
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.backSecondary.color
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.addSubview(plusButton)
    }

    private func setupConstraints() {
        plusButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func didTapButton() {
        let viewModel: TodoViewModel = TodoViewModel()
        let controller = TodoModalViewController(viewModel: viewModel)
        viewModel.view = controller

        let navC = UINavigationController(rootViewController: controller)
        present(navC, animated: true)
    }
}
