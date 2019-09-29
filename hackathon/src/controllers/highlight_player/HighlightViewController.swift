import AVFoundation
import Foundation
import UIKit

class HighlightViewController: UIViewController {

    var highlight: HighlightModel!
    var highlightView: HighlightView {
        return view as! HighlightView
    }
    
    @IBOutlet weak var gradientView: GradientView! {
        didSet {
            gradientView.topColor = UIColor.black
            gradientView.bottomColor = UIColor.black.withAlphaComponent(0.0)
        }
    }
    
    @IBOutlet weak var pushView: UIView! {
        didSet {
            pushView.layer.cornerRadius = 15
            pushView.isHidden = true
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var performerLabel: UILabel!
    @IBOutlet weak var performerImage: UIImageView! {
        didSet {
            performerImage.layer.cornerRadius = 15
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerItem = AVPlayerItem(url: URL(string: highlight.videoUrl)!)
        highlightView.player = AVPlayer(playerItem: playerItem)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        highlightView.player?.play()
        let event = EventModel(id: 0, type: .offside, realTime: Date(), matchTime: 46, videoTime: 34, player: PlayerModel(lastName: "Су-тор-мин", avatar: "https://commons.wikimedia.org/wiki/File:Cel-Zen_(15)_(cropped).jpg"))
        showEvent(event)
    }
    
    @IBAction func didTapClose() {
        dismiss(animated: true)
    }
    
    func showEvent(_ event: EventModel) {
        timeLabel.text = "\(event.matchTime)'"
        eventLabel.text = event.type.name
        if let player = event.player {
            performerLabel.text = player.lastName
            performerLabel.isHidden = false
            if let avatarUrl = URL(string: player.avatar ?? "") {
                performerImage.af_setImage(withURL: avatarUrl)
                performerImage.isHidden = false
            } else {
                performerImage.isHidden = true
            }
        } else {
            performerImage.isHidden = true
            performerLabel.isHidden = true
        }
        
        var pushFrame = pushView.frame
        let pushFrameOrigin = pushFrame
        pushFrame.origin.y = 0 - pushFrame.height
        pushView.frame = pushFrame
        pushView.layer.opacity = 0.0
        pushView.isHidden = false
        
        UIView.animate(withDuration: 1.5) {
            self.pushView.frame = pushFrameOrigin
            self.pushView.layer.opacity = 1.0
        }
    }
}
