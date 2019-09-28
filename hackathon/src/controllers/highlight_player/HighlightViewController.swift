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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerItem = AVPlayerItem(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
        highlightView.player = AVPlayer(playerItem: playerItem)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        highlightView.player?.play()
    }
    
    @IBAction func didTapClose() {
        dismiss(animated: true)
    }
}
