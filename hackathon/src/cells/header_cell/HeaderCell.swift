import Foundation
import UIKit

struct HeaderCellObject {
    let title: String
}

class HeaderCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
}

extension HeaderCell: BaseTableViewCell {
    func configure(for object: Any?) {
        guard let cellObject = object as? HeaderCellObject else { return }

        headerLabel.text = cellObject.title
    }
}
