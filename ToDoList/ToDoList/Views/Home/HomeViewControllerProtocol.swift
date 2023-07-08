import UIKit

protocol HomeViewControllerProtocol: AnyObject {

    var items: [TodoViewModel] { get set }

    @MainActor func setupHeader(title: String, amount: Int)

    @MainActor func reloadData()

    @MainActor func reloadSection()

    @MainActor func reloadRows(at indexPathes: [IndexPath])

    @MainActor func reloadRow(at indexPath: IndexPath)

    @MainActor func deleteRow(at indexPath: IndexPath)

    @MainActor func deleteRows(at indexPathes: [IndexPath])

    func insertRow(at indexPath: IndexPath)

    @MainActor func insertRows(at indexPathes: [IndexPath])
    
    @MainActor func present(modal: UINavigationController)
    
    func showStatusIndicator()

    func hideStatusIndicator()
}
