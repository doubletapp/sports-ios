import AVFoundation
import Foundation
import UIKit

class SendVideoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(ChooseEventCell.self)
        }
    }
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var videoContainer: VideoContainerView! {
        didSet {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPlayerView))
            videoContainer.addGestureRecognizer(tapRecognizer)
        }
    }
    @IBOutlet weak var tableViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var playButton: UIButton!
    
    var isPlaying: Bool = false

    weak var closeDelegate: CloseScreenDelegate?
    weak var matchSourceDelegate: MatchSourceDelegate?

    var videoUrl: URL?
    var startRecordingDate: Date?
    var stopRecordingDate: Date?

    var cellDescriptions: [TableViewCellDescription] = [
        TableViewCellDescription(
            cellType: ChooseEventCell.self,
            object: ChooseEventCellData(time: "15'", title: "Гол Дмитров")
        ),
        TableViewCellDescription(
            cellType: ChooseEventCell.self,
            object: ChooseEventCellData(time: "27'", title: "Пенальти Иванов")
        ),
        TableViewCellDescription(
            cellType: ChooseEventCell.self,
            object: ChooseEventCellData(time: "33'", title: "Штраф Семенов")
        ),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
        
        if let url = videoUrl {

            let playerItem = AVPlayerItem(url: url)
            videoContainer.player = AVPlayer(playerItem: playerItem)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerDidFinishPlaying),
                name: .AVPlayerItemDidPlayToEndTime,
                object: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func reloadData() {
        tableView.isHidden = cellDescriptions.count == 0
        headerLabel.isHidden = cellDescriptions.count == 0

        switch cellDescriptions.count {
            case 0: tableViewHeightContraint.constant = 0
            case 1..<4: tableViewHeightContraint.constant = CGFloat(45 * cellDescriptions.count)
            default: tableViewHeightContraint.constant = 180
        }

        tableView.reloadData()
    }

    @IBAction func closeAction() {
        closeDelegate?.close()
    }
    
    @IBAction func didTapPlay() {
        videoContainer.player?.play()
        isPlaying = true
        UIView.animate(withDuration: 0.8) {
            self.playButton.layer.opacity = 0.0
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
        videoContainer.player?.seek(to: CMTime.zero)
        isPlaying = false
        UIView.animate(withDuration: 0.8) {
            self.playButton.layer.opacity = 1.0
        }
    }

    @IBAction func sendAction() {
        var data: [UploadData] = []

        if let image = createThumbnailOfVideoFromFileURL(videoURL: videoUrl!.absoluteString),
           let imageData = image.jpegData(compressionQuality: 0.9) {
            data.append(
                UploadData(
                    data: imageData,
                    key: "preview", 
                    filename: "preview.jpg", 
                    mimeType: "image/jpeg"
                )
            )
        }

        if let videoData = try? Data(contentsOf: videoUrl!) {
            data.append(
                UploadData(
                    data: videoData,
                    key: "video",
                    filename: "video.mp4",
                    mimeType: "video/mp4"
                )
            )
        }

        guard let match = matchSourceDelegate?.getMatch() else { return }

        view.showLoading()

        UploadVideoRequest(
            data: data,
            matchId: match.id,
            startRealmTime: startRecordingDate!,
            duration: stopRecordingDate!.timeIntervalSince1970 - startRecordingDate!.timeIntervalSince1970
        ).request { [weak self] any, error in
            self?.closeDelegate?.close()
        }
    }

    func createThumbnailOfVideoFromFileURL(videoURL: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: videoURL)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            return nil
        }
    }
}

extension SendVideoViewController: UITableViewDelegate {

}

extension SendVideoViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDescriptions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.configureCell(with: cellDescriptions[indexPath.row], for: indexPath)
    }
}
