import Foundation
import UIKit

protocol MatchScreenDelegate: class {
    func reloadData(for match: MatchModel, callback: @escaping (MatchModel) -> Void)
}

class MatchScreenViewController: UIViewController, CloseScreenDelegate, MatchSourceDelegate {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(ProfileMatchCell.self)
            tableView.register(HeaderCell.self)
            tableView.register(EventCell.self)
            tableView.register(VideosCell.self)
            tableView.layer.shadowColor = UIColor.black.cgColor
            tableView.layer.shadowOpacity = 0.08
            tableView.layer.shadowRadius = 20.0
            tableView.layer.shadowOffset = .zero
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var liveLabelView: UIView!

    var matchModel: MatchModel!
    var cellDescriptions: [TableViewCellDescription] = []
    weak var screenDelegate: MatchScreenDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        liveLabelView.isHidden = matchModel.status != .live
        timeLabel.isHidden = matchModel.minute.isEmpty || matchModel.status != .live
        timeLabel.text = matchModel.minute

        updateData()
    }

    func updateData() {
        cellDescriptions = []


        var headerCellDescriptions = [TableViewCellDescription]()

        headerCellDescriptions.append(
            TableViewCellDescription(
                cellType: ProfileMatchCell.self,
                object: ProfileMatchCellObject(expanded: false, match: matchModel, delegate: nil)
            )
        )
        if matchModel.otherVideos.count > 0 {
            headerCellDescriptions.append(
                TableViewCellDescription(
                    cellType: HeaderCell.self,
                    object: HeaderCellObject(title: "Другие видео")
                )
            )

            headerCellDescriptions.append(
                TableViewCellDescription(
                    cellType: VideosCell.self,
                    object: VideosCellObject(videos: matchModel.otherVideos, isLast: true)
                )
            )
        }


        headerCellDescriptions.append(
            TableViewCellDescription(
                cellType: HeaderCell.self,
                object: HeaderCellObject(title: "Таймлайн")
            )
        )

        let eventsCellDescriptions = matchModel.events.enumerated().map { el -> [TableViewCellDescription]  in
            let event = el.1
            let index = el.0

            var cells = [TableViewCellDescription]()

            let eventCell = TableViewCellDescription(
                cellType: EventCell.self,
                object: EventCellObject(
                    event: event,
                    first: index == 0,
                    last: index == matchModel.events.count - 1
                )
            )

            cells.append(eventCell)

            if event.videos.count > 0 {
                let videosCell = TableViewCellDescription(
                    cellType: VideosCell.self,
                    object: VideosCellObject(videos: event.videos, isLast: index == matchModel.events.count - 1)
                )

                cells.append(videosCell)
            }

            return cells
        }


        cellDescriptions.append(contentsOf: headerCellDescriptions)
        cellDescriptions.append(contentsOf: eventsCellDescriptions.flatMap { $0 })
        
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        var contentInset = tableView.contentInset
        contentInset.bottom = 104
        tableView.contentInset = contentInset

        screenDelegate?.reloadData(for: matchModel) { [weak self] model in
            self?.matchModel = model
            self?.updateData()
        }
    }

    @IBAction func cameraAction() {
        let cameraVC = UIStoryboard(name: "Camera", bundle: nil).instantiateInitialViewController() as! CameraViewController
        cameraVC.closeDelegate = self
        cameraVC.matchSourceDelegate = self
        present(cameraVC, animated: true)
    }

    @IBAction func backAction() {
        dismiss(animated: true, completion: nil)
    }

    func getMatch() -> MatchModel {
        return matchModel
    }
}

extension MatchScreenViewController: UITableViewDelegate {

}

extension MatchScreenViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDescriptions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.configureCell(with: cellDescriptions[indexPath.row], for: indexPath)
    }
}

