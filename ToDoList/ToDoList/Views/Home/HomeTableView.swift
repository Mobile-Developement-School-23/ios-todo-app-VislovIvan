import Foundation
import UIKit

final class IntrinsicTableView: UITableView {
    
    private var height: CGFloat = 0
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard contentSize.height != height else { return }
        height = contentSize.height
        invalidateIntrinsicContentSize()
    }
}
