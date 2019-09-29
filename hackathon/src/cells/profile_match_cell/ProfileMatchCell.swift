import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol ProfileMatchCellDelegate: class {
    func moreAction(cell: ProfileMatchCell)
}

struct ProfileMatchCellObject {
    let expanded: Bool
    let match: MatchModel
    weak var delegate: ProfileMatchCellDelegate?
}

class ProfileMatchCell: UITableViewCell {

    let disposeBag = DisposeBag()
    weak var delegate: ProfileMatchCellDelegate?

    @IBOutlet weak var firstTeamImageView: UIImageView!
    @IBOutlet weak var secondTeamImageView: UIImageView!
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var secondTeamName: UILabel!
    @IBOutlet weak var matchScoreLabel: UILabel!
    @IBOutlet weak var buttonContainer: UIView!
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(SmallVideoCollectionCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    var cellDescriptions: [CollectionViewCellDescription] = [
        CollectionViewCellDescription(
            cellType: SmallVideoCollectionCell.self,
            object: nil
        ),
        CollectionViewCellDescription(
            cellType: SmallVideoCollectionCell.self,
            object: nil
        ),
        CollectionViewCellDescription(
            cellType: SmallVideoCollectionCell.self,
            object: nil
        ),
        CollectionViewCellDescription(
            cellType: SmallVideoCollectionCell.self,
            object: nil
        ),
        CollectionViewCellDescription(
            cellType: SmallVideoCollectionCell.self,
            object: nil
        ),
        CollectionViewCellDescription(
            cellType: SmallVideoCollectionCell.self,
            object: nil
        ),
    ]

    @IBAction func moreAction() {
        delegate?.moreAction(cell: self)
    }
}

extension ProfileMatchCell: BaseTableViewCell {

    func configure(for object: Any?) {
        guard let cellObject = object as? ProfileMatchCellObject else { return }
        let match = cellObject.match
        delegate = cellObject.delegate

        if let firstTeamLogoUrl = URL(string: match.homeTeam.logo) {
            firstTeamImageView.af_setImage(withURL: firstTeamLogoUrl)
        }
        firstTeamName.text = match.homeTeam.name
        if let secondTeamLogoUrl = URL(string: match.awayTeam.logo) {
            secondTeamImageView.af_setImage(withURL: secondTeamLogoUrl)
        }
        secondTeamName.text = match.awayTeam.name
        matchScoreLabel.text = "\(match.homeTeam.score) - \(match.awayTeam.score)"

        let expanded = cellObject.expanded

        buttonContainer.isHidden = !expanded
        collectionContainer.isHidden = !expanded

        collectionView.reloadData()
        collectionView.contentOffset = .zero
    }
}

extension ProfileMatchCell: UICollectionViewDelegate {

}

extension ProfileMatchCell: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDescriptions.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.configureCell(with: cellDescriptions[indexPath.row], for: indexPath)
    }
}
