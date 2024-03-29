import AVFoundation
import Foundation
import UIKit

class HighlightViewController: UIViewController {

    var pushAnimating = false
    var shouldHidePush = true
    var highlight: HighlightModel!
    var highlightView: HighlightView {
        return view as! HighlightView
    }
    var fileUrl: URL?
    var playbackTimer: Timer?
    var timerTicks: Int = 0
    
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
    @IBOutlet weak var pusherView: UIView! {
        didSet {
            pusherView.layer.cornerRadius = 2.0
        }
    }
    @IBOutlet weak var popupHeader: UIView! {
        didSet {
            let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanPopup(_:)))
            popupHeader.addGestureRecognizer(panRecognizer)
        }
    }
    @IBOutlet weak var bottomViewHeightConstriaint: NSLayoutConstraint!
    @IBOutlet weak var firstTeamLogo: UIImageView!
    @IBOutlet weak var secondTeamLogo: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.isHidden = true
        }
    }
    @IBOutlet weak var loaderContainer: UIView!
    @IBOutlet weak var previewContainer: UIImageView!
    
    var eventsDescriptions: [TableViewCellDescription] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageUrl = URL(string: highlight.previewUrl) {
            previewContainer.contentMode = .scaleAspectFill
            previewContainer.af_setImage(withURL: imageUrl)
        }
        
        loaderContainer.showLoading()
        
        if let url = URL(string: highlight.videoUrl) {
            fileUrl = getNewFileURL()
            if let fileUrl = fileUrl {
                Downloader.load(url: url, to: fileUrl) { [weak self] in
                    DispatchQueue.main.async {
                        self?.playButton.isHidden = false
                        self?.loaderContainer.hideLoading()
                        self?.loaderContainer.isHidden = true

                        let playerItem = AVPlayerItem(url: fileUrl)
                        self?.highlightView.player = AVPlayer(playerItem: playerItem)
                        self?.previewContainer.isHidden = true
                        NotificationCenter.default.addObserver(
                            self,
                            selector: #selector(self!.playerDidFinishPlaying),
                            name: .AVPlayerItemDidPlayToEndTime,
                            object: nil
                        )
                    }
                }
            }
        }
        
        if let firstTeamUrl = URL(string: highlight.match.homeTeam.logo) {
            firstTeamLogo.af_setImage(withURL: firstTeamUrl)
        }
        if let secondTeamUrl = URL(string: highlight.match.awayTeam.logo) {
            secondTeamLogo.af_setImage(withURL: secondTeamUrl)
        }
        scoreLabel.text = "\(highlight.match.homeTeam.score) - \(highlight.match.awayTeam.score)"
        
        var first = true
        var counted = 0
        for event in highlight.events {
            counted += 1
            eventsDescriptions.append(
                TableViewCellDescription(
                    cellType: EventCell.self,
                    object: EventCellObject(
                        event: event,
                        first: first,
                        last: counted == highlight.events.count)))
            first = false
        }
    
        tableView.register(EventCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        let headerView = MainTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        headerView.titleLabel.text = "Лента событий"
        tableView.tableHeaderView = headerView
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if let savedFileUrl = fileUrl {
            DispatchQueue.main.async {
                try? FileManager.default.removeItem(at: savedFileUrl)
            }
        }
    }
    
    private func startPlaybackTimer() {
        playbackTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(playbackTimerTick),
            userInfo: nil,
            repeats: true
        )
    }
    
    @IBAction func didTapClose() {
        playbackTimer?.invalidate()
        playbackTimer = nil
        highlightView.player?.pause()
        dismiss(animated: true)
    }
    
    @IBAction func didTapPlay() {
        highlightView.player?.play()
        startPlaybackTimer()
        UIView.animate(withDuration: 0.4) {
            self.playButton.layer.opacity = 0.0
        }
    }
    
    @objc func playerDidFinishPlaying() {
        playbackTimer?.invalidate()
        playbackTimer = nil
        timerTicks = 0
        
        highlightView.player?.seek(to: CMTime.zero)
        UIView.animate(withDuration: 0.4) {
            self.playButton.layer.opacity = 1.0
        }
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
        if pushAnimating {
            shouldHidePush = false
        }
        pushAnimating = true
        
        UIView.animate(withDuration: 1.5) {
            self.pushView.frame = pushFrameOrigin
            self.pushView.layer.opacity = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if !self.shouldHidePush {
                self.shouldHidePush = true
                return
            }
            UIView.animate(withDuration: 1.5, animations: {
                self.pushView.frame = pushFrame
                self.pushView.layer.opacity = 0.0
            }, completion: { completed in
                self.pushView.frame = pushFrameOrigin
                self.pushView.layer.opacity = 1.0
                self.pushView.isHidden = true
                self.pushAnimating = false
            })
        }
    }
    
    @objc func didPanPopup(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        var newContstant = bottomViewHeightConstriaint.constant - translation.y
        if newContstant < 60.0 {
            newContstant = 60.0
        }
        if newContstant > UIScreen.main.bounds.height - 160.0 {
            newContstant = UIScreen.main.bounds.height - 160.0
        }
        bottomViewHeightConstriaint.constant = newContstant
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
    }
    
    @objc private func playbackTimerTick() {
        guard playbackTimer != nil else {
            return
        }
        
        timerTicks += 1
        for event in highlight.events {
            if event.videoTime == timerTicks {
                showEvent(event)
            }
        }
    }
}

extension HighlightViewController: UITableViewDelegate {

}

extension HighlightViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsDescriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.configureCell(with: eventsDescriptions[indexPath.row], for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let event = (eventsDescriptions[indexPath.row].object as! EventCellObject).event
        highlightView.player?.seek(to: CMTime(seconds: Double(event.videoTime ?? 0), preferredTimescale: 1))
        timerTicks = event.videoTime ?? 0
        showEvent(event)
    }
}
