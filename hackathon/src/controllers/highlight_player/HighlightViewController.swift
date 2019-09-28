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
    }
    
    @IBAction func didTapClose() {
        dismiss(animated: true)
    }
    
    func showEvent(_ event: EventModel) {
        timeLabel.text = "\(event.matchTime)'"
        timeLabel
    }
}
