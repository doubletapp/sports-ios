import Foundation
import UIKit

struct VideosCellObject {
    let videos: [VideoModel]
}

class VideosCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(SmallVideoCollectionCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    var cellDescriptions: [CollectionViewCellDescription] = []
//        CollectionViewCellDescription(
//            cellType: SmallVideoCollectionCell.self,
//            object: nil
//        ),
//        CollectionViewCellDescription(
//            cellType: SmallVideoCollectionCell.self,
//            object: nil
//        ),
//        CollectionViewCellDescription(
//            cellType: SmallVideoCollectionCell.self,
//            object: nil
//        ),
//        CollectionViewCellDescription(
//            cellType: SmallVideoCollectionCell.self,
//            object: nil
//        ),
//        CollectionViewCellDescription(
//            cellType: SmallVideoCollectionCell.self,
//            object: nil
//        ),
//        CollectionViewCellDescription(
//            cellType: SmallVideoCollectionCell.self,
//            object: nil
//        ),
//    ]


}

extension VideosCell: BaseTableViewCell {

    func configure(for object: Any?) {
        guard let cellObject = object as? VideosCellObject else { return }

        cellDescriptions = cellObject.videos.map {
            CollectionViewCellDescription(
                cellType: SmallVideoCollectionCell.self,
                object: SmallVideoCollectionCellObject(video: $0)
            )
        }

        collectionView.reloadData()
        collectionView.contentOffset = .zero
    }
}

extension VideosCell: UICollectionViewDelegate {

}

extension VideosCell: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDescriptions.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.configureCell(with: cellDescriptions[indexPath.row], for: indexPath)
    }
}
