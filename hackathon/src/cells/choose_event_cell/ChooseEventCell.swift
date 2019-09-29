import Foundation
import UIKit

struct ChooseEventCellData {
    let time: String
    let title: String
}

class ChooseEventCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
}

extension ChooseEventCell: BaseTableViewCell {

    func configure(for object: Any?) {
        guard let cellObject = object as? ChooseEventCellData else { return }

        timeLabel.text = cellObject.time
        eventNameLabel.text = cellObject.title
    }

}
