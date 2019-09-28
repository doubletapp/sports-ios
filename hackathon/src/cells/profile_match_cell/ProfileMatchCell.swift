import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol ProfileMatchCellDelegate: class {
    func moreAction(cell: ProfileMatchCell)
}

struct ProfileMatchCellObject {
    let expanded: Bool
    weak var delegate: ProfileMatchCellDelegate?
}

class ProfileMatchCell: UITableViewCell {

    let disposeBag = DisposeBag()
    weak var delegate: ProfileMatchCellDelegate?

    @IBOutlet weak var firstTeamImageView: UIImageView! {
        didSet {
            firstTeamImageView.rx
                .observe(CGRect.self, "bounds")
                .subscribe(onNext: { [weak self] _ in
                    guard let sself = self else { return }
                    sself.firstTeamImageView.cornerRadius = sself.firstTeamImageView.bounds.width / 2
                })
                .disposed(by: disposeBag)
        }
    }
    @IBOutlet weak var secondTeamImageView: UIImageView! {
        didSet {
            secondTeamImageView.rx
                .observe(CGRect.self, "bounds")
                .subscribe(onNext: { [weak self] _ in
                    guard let sself = self else { return }
                    sself.secondTeamImageView.cornerRadius = sself.secondTeamImageView.bounds.width / 2
                })
                .disposed(by: disposeBag)
        }
    }
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

        delegate = cellObject.delegate

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
