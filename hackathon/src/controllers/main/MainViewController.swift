import Foundation
import UIKit

class MainViewController: UIViewController, MatchScreenDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var matchDescriptions: [TableViewCellDescription] = []
    var highlightDescriptions: [CollectionViewCellDescription] = []

    var matches: [MatchModel] = []

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
        loadData(matches: [], highlights: [])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateData(callback: {})
    }

    func updateData(callback: @escaping () -> Void) {

        var matches: [MatchModel] = []
        var highlights: [HighlightModel] = []

        let group = DispatchGroup()

        group.enter()
        GetMatchesRequest().request { any, error in
            if let response = any as? [String: Any] {
                matches = MatchModel.models(from: response)
            }
            group.leave()
        }

        group.enter()
        GetHighlightsRequest().request { any, error in
            if let response = any as? [String: Any] {
                highlights = HighlightModel.models(from: response)
            }
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) { [weak self] in
            self?.loadData(matches: matches, highlights: highlights)
            callback()
        }
    }

    @IBAction func didTapProfile() {
        guard let profileVC = UIStoryboard(name: "UserProfile", bundle: nil).instantiateInitialViewController() else {
            return
        }
        present(profileVC, animated: true)
    }
    
    private func loadData(matches: [MatchModel], highlights: [HighlightModel]) {
        matchDescriptions = []

        self.matches = matches

        matchDescriptions = matches.map {
            TableViewCellDescription(cellType: MatchTableViewCell.self, object: $0)
        }

        highlightDescriptions = highlights.map {
            CollectionViewCellDescription(cellType: HighlightPreviewCell.self, object: $0)
        }

        tableView.reloadData()
        collectionView.reloadData()
    }

    func reloadData(for match: MatchModel, callback: @escaping (MatchModel) -> Void) {
        let marchId = match.id
        updateData { [weak self] in
            if let match = self?.matches.first(where: { $0.id == marchId }) {
                callback(match)
            }
        }
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
        guard let matchVC = UIStoryboard(name: "Match", bundle: nil).instantiateInitialViewController() as? MatchScreenViewController else {
            return
        }
        matchVC.matchModel = match
        matchVC.screenDelegate = self
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
