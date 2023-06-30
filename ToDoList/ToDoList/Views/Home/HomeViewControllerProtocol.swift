import UIKit

protocol HomeViewControllerProtocol: AnyObject {

    var items: [TodoViewModel] { get set }

    func setupHeader(title: String, amount: Int)

    func reloadData()

    func reloadSection()

    func reloadRows(at indexPathes: [IndexPath])

    func reloadRow(at indexPath: IndexPath)

    func deleteRow(at indexPath: IndexPath)

    func deleteRows(at indexPathes: [IndexPath])

    func insertRow(at indexPath: IndexPath)

    func insertRows(at indexPathes: [IndexPath])
    
    func present(modal: UINavigationController)
}
