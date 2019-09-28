import AVFoundation
import Foundation
import UIKit

class HighlightViewController: UIViewController {

    var highlight: HighlightModel!

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
            playerLayer.videoGravity = .resizeAspectFill
        }
    }
    
    var playerLayer: AVPlayerLayer! {
        return view.layer as? AVPlayerLayer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let playerItem = AVPlayerItem(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
        player = AVPlayer(playerItem: playerItem)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        player?.play()
    }
}
