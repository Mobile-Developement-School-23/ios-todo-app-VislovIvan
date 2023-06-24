import UIKit

protocol TodoViewModelProtocol {

    func viewDidLoad()

    func deadlineDidChange(isEnabled: Bool)

    func deadLineDidClick()

    func textDidChange(text: String)

    func importanceDidChange(importance: Importance)

    func datePickerChanged(date: Date)

    func saveButtonDidTap()

    func deleteButtonDidTap()
}
