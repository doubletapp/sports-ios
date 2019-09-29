import Foundation
import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(ProfileMatchCell.self)
            tableView.layer.shadowColor = UIColor.black.cgColor
            tableView.layer.shadowOpacity = 0.08
            tableView.layer.shadowRadius = 20.0
            tableView.layer.shadowOffset = .zero
        }
    }


    var expandedCellIndex: Int?
    var cellDescriptions: [TableViewCellDescription] = []
    var matchModels: [MatchModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        for match in matchModels {
            cellDescriptions.append(
                TableViewCellDescription(
                    cellType: ProfileMatchCell.self,
                    object: ProfileMatchCellObject(expanded: false, match: match, delegate: self)))
        }
        
        tableView.reloadData()
    }

    @IBAction func backAction() {
        dismiss(animated: true)
    }

    func updateData() {
        cellDescriptions = cellDescriptions.enumerated().map { index, element in
            if index == expandedCellIndex {
                return TableViewCellDescription(
                    cellType: ProfileMatchCell.self,
                    object: ProfileMatchCellObject(expanded: true, match: matchModels[0], delegate: self))
            }
            return TableViewCellDescription(
                cellType: ProfileMatchCell.self,
                object: ProfileMatchCellObject(expanded: false, match: matchModels[1], delegate: self)
            )
        }

        tableView.reloadData()
    }
}

extension UserProfileViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expandedCellIndex = indexPath.row
        updateData()
    }
}

extension UserProfileViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDescriptions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.configureCell(with: cellDescriptions[indexPath.row], for: indexPath)
    }
}

extension UserProfileViewController: ProfileMatchCellDelegate {

    func moreAction(cell: ProfileMatchCell) {
        guard let index = tableView.indexPath(for: cell)?.row else { return }
    }
}
