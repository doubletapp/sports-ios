import Foundation
import UIKit

struct EventCellObject {
    let time: String
    let playerAvatar: String
    let eventName: String
    let playerName: String
    let first: Bool
    let last: Bool
}

class EventCell: UITableViewCell {

    @IBOutlet weak var topTimeline: UIView!
    @IBOutlet weak var bottomTimeline: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playerAvatar: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
}

extension EventCell: BaseTableViewCell {

    func configure(for object: Any?) {
        guard let cellObject = object as? EventCellObject else { return }

        topTimeline.isHidden = cellObject.first
        bottomTimeline.isHidden = cellObject.last
        timeLabel.text = cellObject.time
        eventNameLabel.text = cellObject.eventName
        playerNameLabel.text = cellObject.playerName
    }
}
