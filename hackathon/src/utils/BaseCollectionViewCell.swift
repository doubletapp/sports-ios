import Foundation
import UIKit

protocol BaseCollectionViewCell {

    static func cellIdentifier() -> String
    func configure(for object: Any?)
}

extension BaseCollectionViewCell where Self: UICollectionViewCell {

    static func cellIdentifier() -> String {
        return String(describing: self)
    }

    func configureCell(for object: Any?) {

    }
}
