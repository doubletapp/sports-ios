import Foundation
import UIKit

struct CollectionViewCellDescription {
    let cellType: BaseCollectionViewCell.Type
    var object: Any?

    init(cellType: BaseCollectionViewCell.Type, object: Any?) {
        self.cellType = cellType
        self.object = object
    }
}

let UICollectionViewAutomaticDimension: CGFloat = -1.0

extension UICollectionView {

    func register<T: BaseCollectionViewCell>(_ classType: T.Type) {
        register(UINib(nibName: classType.cellIdentifier(), bundle: nil),
                forCellWithReuseIdentifier: classType.cellIdentifier())
    }

    func configureCell(with cellDescription: CollectionViewCellDescription,
                       for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(
                withReuseIdentifier: cellDescription.cellType.cellIdentifier(),
                for: indexPath
        )
        if let baseCell = cell as? BaseCollectionViewCell {
            baseCell.configure(for: cellDescription.object)
        }
        return cell
    }
}

