import AVFoundation
import Foundation
import UIKit

class HighlightViewController: UIViewController {

    var highlight: HighlightModel!
    var highlightView: HighlightView {
        return view as! HighlightView
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
}
