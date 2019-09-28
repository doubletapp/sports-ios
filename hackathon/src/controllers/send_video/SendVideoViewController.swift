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
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var tableViewHeightContraint: NSLayoutConstraint!

    weak var closeDelegate: CloseScreenDelegate?
    var videoUrl: URL?

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