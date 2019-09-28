import Foundation
import UIKit

class HighlightPreviewCell: UICollectionViewCell {
    @IBOutlet var backgroundPreview: UIImageView!
    @IBOutlet var gradientView: GradientView! {
        didSet {
            gradientView.topColor = UIColor.black.withAlphaComponent(0.0)
            gradientView.bottomColor = UIColor.black.withAlphaComponent(1.0)
        }
    }
    @IBOutlet var firstTeamLogo: UIImageView!
    @IBOutlet var secondTeamLogo: UIImageView!
    @IBOutlet var scoreLabel: UILabel!
}

extension HighlightPreviewCell: BaseCollectionViewCell {
    func configure(for object: Any?) {
        guard let highlight = object as? HighlightModel else {
            return
        }
        contentView.layer.cornerRadius = 15.0
        contentView.clipsToBounds = true
        if let previewUrl = URL(string: highlight.previewUrl) {
            backgroundPreview.af_setImage(withURL: previewUrl)
        }
        if let firstTeamLogoUrl = URL(string: highlight.match.homeTeam.logo) {
            firstTeamLogo.af_setImage(withURL: firstTeamLogoUrl)
        }
        if let secondTeamLogoUrl = URL(string: highlight.match.awayTeam.logo) {
            secondTeamLogo.af_setImage(withURL: secondTeamLogoUrl)
        }
        scoreLabel.text = "\(highlight.match.homeTeam.score) : \(highlight.match.awayTeam.score)"
        backgroundPreview.layer.zPosition = -1
    }
}
