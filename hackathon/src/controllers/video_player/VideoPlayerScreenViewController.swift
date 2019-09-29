import Foundation
import UIKit
import AVFoundation
import AlamofireImage

protocol VideoPlayerScreenDelegate: class {

    func closeVideo()
}

class VideoPlayerScreenViewController: UIViewController {

    var videoModel: VideoModel!

    weak var delegate: VideoPlayerScreenDelegate?
    @IBOutlet weak var videoContainer: VideoContainerView! {
        didSet {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPlayerView))
            videoContainer.addGestureRecognizer(tapRecognizer)
        }
    }
    @IBOutlet weak var loaderContainer: UIView!
    @IBOutlet weak var imagePreviewContainer: UIImageView!


    deinit {
        if let savedFileUrl = fileUrl {
            DispatchQueue.main.async {
                try? FileManager.default.removeItem(at: savedFileUrl)
            }
        }
    }

    @IBAction func closeAction() {
        delegate?.closeVideo()
    }

    @IBOutlet weak var playButton: UIButton!

    var isPlaying: Bool = false

    var fileUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        playButton.isHidden = true
        loaderContainer.showLoading()


        if let imageUrl = URL(string: videoModel.previewUrl) {
            imagePreviewContainer.af_setImage(withURL: imageUrl)
        }

        if let url = URL(string: videoModel.videoUrl) {
            fileUrl = getNewFileURL()
            if let fileUrl = fileUrl {
                Downloader.load(url: url, to: fileUrl) { [weak self] in
                    DispatchQueue.main.async {
                        self?.playButton.isHidden = false
                        self?.loaderContainer.hideLoading()
                        self?.loaderContainer.isHidden = true

                        let playerItem = AVPlayerItem(url: fileUrl)
                        self?.videoContainer.player = AVPlayer(playerItem: playerItem)
                        NotificationCenter.default.addObserver(
                            self,
                            selector: #selector(VideoPlayerScreenViewController.playerDidFinishPlaying),
                            name: .AVPlayerItemDidPlayToEndTime,
                            object: nil
                        )
                    }
                }
            }
        }
    }

    @objc func didTapPlayerView() {
        if isPlaying {
            isPlaying = false
            videoContainer.player?.pause()
            UIView.animate(withDuration: 0.8) {
                self.playButton.layer.opacity = 1.0
            }
        }
    }

    @objc func playerDidFinishPlaying() {
        imagePreviewContainer.isHidden = false
        videoContainer.player?.seek(to: CMTime.zero)
        isPlaying = false
        UIView.animate(withDuration: 0.8) {
            self.playButton.layer.opacity = 1.0
        }
    }

    @IBAction func didTapPlay() {
        imagePreviewContainer.isHidden = true
        videoContainer.player?.play()
        isPlaying = true
        UIView.animate(withDuration: 0.8) {
            self.playButton.layer.opacity = 0.0
        }
    }
}
