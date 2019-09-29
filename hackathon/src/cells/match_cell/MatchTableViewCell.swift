import Foundation
import UIKit
import AlamofireImage

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
    
    @IBOutlet var matchTimeLabel: UILabel!
    @IBOutlet var liveTimeLabel: UILabel!
    @IBOutlet var firstTeamLogo: UIImageView!
    @IBOutlet var secondTeamLogo: UIImageView!
    @IBOutlet var firstTeamName: UILabel!
    @IBOutlet var secondTeamName: UILabel!
    @IBOutlet var firstTeamScore: UILabel!
    @IBOutlet var secondTeamScore: UILabel!
    @IBOutlet var liveRoundedView: UIView! {
        didSet {
            liveRoundedView.layer.cornerRadius = 15
        }
    }
}

extension MatchTableViewCell: BaseTableViewCell {

    func configure(for object: Any?) {
        guard let match = object as? MatchModel else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        matchTimeLabel.text = formatter.string(from: match.startDateTime)
        liveTimeLabel.text = match.minute
        liveTimeLabel.isHidden = match.minute.isEmpty || match.status != .live
        liveRoundedView.isHidden = match.status != .live
        if let firstLogoUrl = URL(string: match.homeTeam.logo) {
            firstTeamLogo.af_setImage(withURL: firstLogoUrl)
        }
        if let secondLogoUrl = URL(string: match.awayTeam.logo) {
            secondTeamLogo.af_setImage(withURL: secondLogoUrl)
        }
        firstTeamName.text = match.homeTeam.name
        secondTeamName.text = match.awayTeam.name
        firstTeamScore.text = "\(match.homeTeam.score)"
        secondTeamScore.text = "\(match.awayTeam.score)"
    }
}
