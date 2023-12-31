import UIKit
import DesignSystem

final class HomeViewController: UIViewController {

    var items: [TodoViewModel] = []

    private class Constants {
        static let widthPlusButton: CGFloat = 44.0
        static let marginPlusButton: CGFloat = 54.0
        static let shadowRadius: CGFloat = 20.0
        static let fontstize: CGFloat = 15.0
    }

    private var viewModel: HomeViewModelProtocol = HomeViewModel()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        return table
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.imagePlusCircleFill.image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = Constants.shadowRadius
        button.addTarget(self, action: #selector(didPlusButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var showAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("Показать", for: .normal)
        button.setTitleColor(Color.blue.color, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontstize)
        return button
    }()

    private let headerView = TaskCellHeader()
}

extension HomeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.view = self

        navigationItem.title = "Мои дела"

        setupLayouts()
        setupConstraints()
        setupTable()
        setupGesturesAndObservers()

        tableView.delegate = self
        tableView.dataSource = self

        viewModel.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        plusButton.layer.cornerRadius = plusButton.frame.size.width / 2
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - HomeViewControllerProtocol

extension HomeViewController: HomeViewControllerProtocol {

    @MainActor func setupHeader(title: String, amount: Int) {
        headerView.setButtonTitle(with: title)
        headerView.setTask(with: amount)
    }

    @MainActor func reloadRows(at indexPathes: [IndexPath]) {
        tableView.reloadRows(at: indexPathes, with: .none)
    }

    @MainActor func reloadSection() {
        tableView.reloadSections(.init(integer: 0), with: .fade)
    }

    @MainActor func present(modal: UINavigationController) {
        self.present(modal, animated: true)
    }

    @MainActor func reloadData() {
        tableView.reloadData()
    }

    @MainActor func reloadRow(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    @MainActor func deleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .none)
    }

    @MainActor func deleteRows(at indexPathes: [IndexPath]) {
        tableView.deleteRows(at: indexPathes, with: .fade)
    }

    @MainActor func insertRow(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .none)
    }

    @MainActor func insertRows(at indexPathes: [IndexPath]) {
        tableView.insertRows(at: indexPathes, with: .fade)
    }
    
    func needToReloadTable() {
        self.tableView.reloadData()
    }
    
    func showStatusIndicator() {
        headerView.showActivityIndicator()
    }
    
    func hideStatusIndicator() {
        headerView.hideActivityIndicator()
    }
}

// MARK: - Private methods

private extension HomeViewController {

    func setupTable() {
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        tableView.register(TaskInputCell.self, forCellReuseIdentifier: TaskInputCell.identifier)
        tableView.register(TaskCellHeader.self, forHeaderFooterViewReuseIdentifier: TaskCellHeader.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setupLayouts() {
        view.backgroundColor = Color.backiOSPrimary.color

        [tableView, plusButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            plusButton.widthAnchor.constraint(equalToConstant: Constants.widthPlusButton),
            plusButton.heightAnchor.constraint(equalToConstant: Constants.widthPlusButton),
            plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.marginPlusButton)
        ])
    }

    func setupGesturesAndObservers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {

    // MARK: - Preview
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider: UIContextMenuActionProvider = { _ in
            return UIMenu(title: "Preview", children: [
                UIAction(title: "Посмотреть") { [weak self] _ in
                    guard let self = self else { return }
                    let model = self.items[indexPath.row]
                    self.viewModel.openModal(with: model)
                },
                UIAction(title: "Удалить") { [weak self] _ in
                    guard let self = self else { return }
                    self.viewModel.delete(at: indexPath)
                }
            ])
        }

        let config = UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: {
            [weak self] () -> UIViewController? in
            guard let self = self else { return nil }

            let item = self.items[indexPath.row]
            let controller = TodoModalViewController(viewModel: item)
            item.modal = controller

            let navigationController = UINavigationController(rootViewController: controller)
            return navigationController
        }, actionProvider: actionProvider)
        return config
    }

    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let previewedController = animator.previewViewController else { return }
        animator.addCompletion {
            self.present(previewedController, animated: true)
        }
    }

    // MARK: - Cells settings
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == self.items.count {
            let inputCell = tableView.dequeueReusableCell(withIdentifier: TaskInputCell.identifier, for: indexPath)
            guard let inputCell = inputCell as? TaskInputCell else {
                return UITableViewCell()
            }
            inputCell.action = { [weak self] text in
                self?.viewModel.createTask(with: text)
            }
            inputCell.selectionStyle = .none
            return inputCell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 52, bottom: 0, right: 0)
        cell.selectionStyle = .none

        guard let customCell = cell as? TaskCell else {
            return UITableViewCell()
        }

        let todoModel = self.items[indexPath.row]
        customCell.configure(with: todoModel.state)
        customCell.action = { [weak self] in
            guard let self = self else { return }
            let model = self.items[indexPath.row]
            self.viewModel.toggleStatus(on: model, at: indexPath)
        }

        return customCell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.model = TaskCellHeaderModel(
            amount: 0,
            action: { [weak self] _ in
                self?.viewModel.toggleCompletedTasks()
            }
        )
        viewModel.setupHeader()
        return headerView
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) is TaskCell else { return }
        let model = self.items[indexPath.row]
        self.viewModel.openModal(with: model)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard tableView.cellForRow(at: indexPath) is TaskCell else { return nil }
        
        let infoButton = UIContextualAction(style: .normal, title: "", handler: { [weak self] (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            guard let self = self else { return success(true) }
            let model = self.items[indexPath.row]
            
            self.viewModel.openInfoModal(with: model)
            
            success(true)
        })
        
        let deleteButton = UIContextualAction(style: .destructive, title: "", handler: { [weak self] (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            guard let self = self else { return success(true) }
            self.viewModel.delete(at: indexPath)
            success(true)
        })
        
        infoButton.image = Image.iconInfo.image
        infoButton.backgroundColor = Color.grayLight.color
        
        deleteButton.image = Image.iconTrash.image
        deleteButton.backgroundColor = Color.red.color
        
        return UISwipeActionsConfiguration(actions: [deleteButton, infoButton])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard tableView.cellForRow(at: indexPath) is TaskCell else { return nil }

        let acceptButton = UIContextualAction(style: .normal, title: "", handler: { [weak self] (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            guard let self = self else { return success(true) }
            let model = self.items[indexPath.row]
            self.viewModel.toggleStatus(on: model, at: indexPath)
            success(true)
        })
        acceptButton.image = Image.iconStatusOn.image
        acceptButton.backgroundColor = Color.green.color
        return UISwipeActionsConfiguration(actions: [acceptButton])
    }
}

// MARK: - Action methods

private extension HomeViewController {

    @objc func didPlusButtonTap() {
        self.viewModel.openModal(with: nil)
    }

    @objc func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        tableView.contentInset.bottom = keyboardHeight
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset.bottom = 0
    }

    @objc func dismissKeyboard() {
        tableView.endEditing(true)
    }
}
