import Foundation
import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var matchDescriptions: [TableViewCellDescription] = []
    
    override func viewDidLoad() {
        tableView.register(MatchTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        loadData()
    }
    
    private func loadData() {
        let sampleMatch1 = MatchModel(
            id: 1,
            startDateTime: Date(),
            homeTeam: TeamModel(
                id: 1,
                logo: "https://s5o.ru/storage/simple/ru/edt/54/12/90/42/ruebe59547fd7.jpeg",
                name: "Liverpool",
                score: 3),
            awayTeam: TeamModel(
                id: 2,
                logo: "https://s5o.ru/storage/simple/ru/edt/27/36/74/46/rue42a147af8f.jpg",
                name: "Manchester City",
                score: 1),
            status: MatchStatus.live,
            minute: "46'",
            events: [])
        matchDescriptions.append(TableViewCellDescription(cellType: MatchTableViewCell.self, object: sampleMatch1))
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate {

}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchDescriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.configureCell(with: matchDescriptions[indexPath.row], for: indexPath)
    }
}
