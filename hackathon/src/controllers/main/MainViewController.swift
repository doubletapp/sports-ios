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
        tableView.tableHeaderView = MainTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        
        collectionView.register(HighlightPreviewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        loadData(models: [])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateData()
    }

    func updateData() {
        GetMatchesRequest().request { [weak self] any, error in
            if let response = any as? [String: Any] {
                self?.loadData(models: MatchModel.models(from: response))
            }
        }
    }

    @IBAction func didTapProfile() {
        guard let profileVC = UIStoryboard(name: "UserProfile", bundle: nil).instantiateInitialViewController() else {
            return
        }
        present(profileVC, animated: true)
    }
    
    private func loadData(models: [MatchModel]) {
        matchDescriptions = []

        models.forEach { model in
            matchDescriptions.append(TableViewCellDescription(cellType: MatchTableViewCell.self, object: model))
        }
        
        tableView.reloadData()
        
//        let sampleHighlight = HighlightModel(
//            id: 0,
//            videoUrl: "http://sports.ru",
//            previewUrl: "https://s5o.ru/storage/simple/ru/edt/ad/98/d9/85/rue84bafa3c0c.jpg",
//            match: sampleMatch1,
//            fragments: [],
//            events: [])
//
//        highlightDescriptions.append(CollectionViewCellDescription(cellType: HighlightPreviewCell.self, object: sampleHighlight))
//        highlightDescriptions.append(CollectionViewCellDescription(cellType: HighlightPreviewCell.self, object: sampleHighlight))
//        highlightDescriptions.append(CollectionViewCellDescription(cellType: HighlightPreviewCell.self, object: sampleHighlight))
//        highlightDescriptions.append(CollectionViewCellDescription(cellType: HighlightPreviewCell.self, object: sampleHighlight))
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
        guard let matchVC = UIStoryboard(name: "Match", bundle: nil).instantiateInitialViewController() else {
            return
        }
        (matchVC as! MatchScreenViewController).matchModel = match
        present(matchVC, animated: true)
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
        guard let highlightVC = UIStoryboard(name: "Highlight", bundle: nil).instantiateInitialViewController() else { return }
        (highlightVC as! HighlightViewController).highlight = highlight
        present(highlightVC, animated: true)
    }
}
