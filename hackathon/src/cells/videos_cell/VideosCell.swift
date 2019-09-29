import Foundation
import UIKit

struct VideosCellObject {
    let videos: [VideoModel]
    let isLast: Bool
}

class VideosCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(SmallVideoCollectionCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    @IBOutlet weak var timelineView: UIView!

    var cellDescriptions: [CollectionViewCellDescription] = []
}

extension VideosCell: BaseTableViewCell {

    func configure(for object: Any?) {
        guard let cellObject = object as? VideosCellObject else { return }

        timelineView.isHidden = cellObject.isLast

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
