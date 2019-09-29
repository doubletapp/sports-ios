import Foundation
import UIKit
import AlamofireImage

struct SmallVideoCollectionCellObject {
    let video: VideoModel
    weak var delegate: SmallVideoCollectionCellDelegate?
}

protocol SmallVideoCollectionCellDelegate: class {

    func selectVideo(video: VideoModel)
}

class SmallVideoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImage: UIImageView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            backgroundImage.isUserInteractionEnabled = true
            backgroundImage.addGestureRecognizer(tap)
        }
    }


    weak var delegate: SmallVideoCollectionCellDelegate?

    var video: VideoModel?
}

extension SmallVideoCollectionCell: BaseCollectionViewCell {

    func configure(for object: Any?) {
        backgroundImage.af_cancelImageRequest()
        backgroundImage.image = nil
        guard let cellObject = object as? SmallVideoCollectionCellObject else { return }

        delegate = cellObject.delegate
        video = cellObject.video
        
        if let url = URL(string: cellObject.video.previewUrl) {
            backgroundImage.af_setImage(withURL: url)
        }
    }

    @objc func tapAction() {
        guard let video = video else { return }
        
        delegate?.selectVideo(video: video)
    }
}
