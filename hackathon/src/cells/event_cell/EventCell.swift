import Foundation
import UIKit
import AlamofireImage

struct EventCellObject {
    let event: EventModel
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
        playerAvatar.af_cancelImageRequest()
        playerAvatar.image = nil

        guard let cellObject = object as? EventCellObject else { return }

        topTimeline.isHidden = cellObject.first
        bottomTimeline.isHidden = cellObject.last
        timeLabel.text = String(cellObject.event.matchTime)
        eventNameLabel.text = cellObject.event.type.name


        if let player = cellObject.event.player {
            playerAvatar.isHidden = false
            playerNameLabel.isHidden = false
            playerNameLabel.text = player.lastName
            if let avatar = player.avatar, let avatarUrl = URL(string: avatar) {
                playerAvatar.isHidden = false
                playerAvatar.af_setImage(withURL: avatarUrl)
            } else {
                playerAvatar.isHidden = true
            }
        } else {
            playerNameLabel.isHidden = true
            playerAvatar.isHidden = true
        }
    }
}
