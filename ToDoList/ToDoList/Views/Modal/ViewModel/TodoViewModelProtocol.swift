import UIKit

protocol TodoViewModelProtocol {

    @MainActor func deadlineDidChange(isEnabled: Bool)

    @MainActor func deadLineDidClick()

    @MainActor func textDidChange(text: String)

    @MainActor func importanceDidChange(importance: Importance)

    @MainActor func datePickerChanged(date: Date)

    @MainActor func saveButtonDidTap()

    @MainActor func deleteButtonDidTap()
}
