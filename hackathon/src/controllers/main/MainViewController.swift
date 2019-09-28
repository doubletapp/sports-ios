import Foundation
import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var matchDescriptions: [TableViewCellDescription] = []
    var highlightDescriptions: [CollectionViewCellDescription] = []
    
    override func viewDidLoad() {
        tableView.register(MatchTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        collectionView.register(HighlightPreviewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        loadData()
    }
    
    @IBAction func didTapProfile() {
        print("tap profile")
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
        matchDescriptions.append(TableViewCellDescription(cellType: MatchTableViewCell.self, object: sampleMatch1))
        matchDescriptions.append(TableViewCellDescription(cellType: MatchTableViewCell.self, object: sampleMatch1))
        matchDescriptions.append(TableViewCellDescription(cellType: MatchTableViewCell.self, object: sampleMatch1))
        tableView.reloadData()
        
        let sampleHighlight = HighlightModel(
            id: 0,
            videoUrl: "http://sports.ru",
            previewUrl: "https://s5o.ru/storage/simple/ru/edt/ad/98/d9/85/rue84bafa3c0c.jpg",
            match: sampleMatch1,
            fragments: [],
            events: [])
        
        highlightDescriptions.append(CollectionViewCellDescription(cellType: HighlightPreviewCell.self, object: sampleHighlight))
        highlightDescriptions.append(CollectionViewCellDescription(cellType: HighlightPreviewCell.self, object: sampleHighlight))
        highlightDescriptions.append(CollectionViewCellDescription(cellType: HighlightPreviewCell.self, object: sampleHighlight))
        highlightDescriptions.append(CollectionViewCellDescription(cellType: HighlightPreviewCell.self, object: sampleHighlight))
        collectionView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let match = matchDescriptions[indexPath.row].object as? MatchModel else { return }
        print("View match \(match.id)")
    }
}

extension MainViewController: UICollectionViewDelegate {

}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return highlightDescriptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.configureCell(with: highlightDescriptions[indexPath.row], for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 135, height: 165)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let highlight = highlightDescriptions[indexPath.row].object as? HighlightModel else { return }
        print("View highlight \(highlight.id)")
    }
}
