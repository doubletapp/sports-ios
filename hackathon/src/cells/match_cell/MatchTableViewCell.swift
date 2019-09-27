import Foundation
import UIKit

class MatchTableViewCell: UITableViewCell {

    @IBOutlet var cardView: UIView! {
        didSet {
            cardView.layer.cornerRadius = 12
            cardView.layer.shadowColor = UIColor(netHex: 0xD7D7D7).cgColor
            cardView.layer.shadowOpacity = 0.6
            cardView.layer.shadowRadius = 3.0
            cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        }
    }
}

extension MatchTableViewCell: BaseTableViewCell {

}
