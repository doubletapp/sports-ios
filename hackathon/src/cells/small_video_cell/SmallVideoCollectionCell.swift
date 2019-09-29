import Foundation
import UIKit
import AlamofireImage

struct SmallVideoCollectionCellObject {
    let video: VideoModel
}

class SmallVideoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!

}

extension SmallVideoCollectionCell: BaseCollectionViewCell {

    func configure(for object: Any?) {
        backgroundImage.af_cancelImageRequest()
        backgroundImage.image = nil
        guard let cellObject = object as? SmallVideoCollectionCellObject else { return }

        if let url = URL(string: cellObject.video.previewUrl) {
            backgroundImage.af_setImage(withURL: url)
        }
    }
}
