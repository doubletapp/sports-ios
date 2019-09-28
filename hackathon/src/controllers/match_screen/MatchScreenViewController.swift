import Foundation
import UIKit

class MatchScreenViewController: UIViewController {

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

    var matchModel: MatchModel!
    var cellDescriptions: [TableViewCellDescription] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        cellDescriptions = [
            TableViewCellDescription(
                cellType: ProfileMatchCell.self,
                object: ProfileMatchCellObject(expanded: false, match: matchModel, delegate: nil)
            ),
            TableViewCellDescription(
                cellType: HeaderCell.self,
                object: HeaderCellObject(title: "Таймлайн")
            ),
            TableViewCellDescription(
                cellType: EventCell.self,
                object: EventCellObject(
                    time: "56'", 
                    playerAvatar: "",
                    eventName: "Гол", 
                    playerName: "Дмитров", 
                    first: true,
                    last: false
                )
            ),
            TableViewCellDescription(
                cellType: VideosCell.self,
                object: VideosCellObject()
            ),
            TableViewCellDescription(
                cellType: EventCell.self,
                object: EventCellObject(
                    time: "56'",
                    playerAvatar: "",
                    eventName: "Гол",
                    playerName: "Дмитров",
                    first: false,
                    last: false
                )
            ),
            TableViewCellDescription(
                cellType: VideosCell.self,
                object: VideosCellObject()
            ),
            TableViewCellDescription(
                cellType: EventCell.self,
                object: EventCellObject(
                    time: "56'",
                    playerAvatar: "",
                    eventName: "Гол",
                    playerName: "Дмитров",
                    first: false,
                    last: true
                )
            ),
        ]

        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        var contentInset = tableView.contentInset
        contentInset.bottom = 104
        tableView.contentInset = contentInset
    }

    @IBAction func cameraAction() {
        let cameraVC = UIStoryboard(name: "Camera", bundle: nil).instantiateInitialViewController()!
        present(cameraVC, animated: true)
    }

    @IBAction func backAction() {
        dismiss(animated: true, completion: nil)
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

