import Foundation
import UIKit

protocol BaseTableViewCell {

    static func cellIdentifier() -> String
    static var height: CGFloat { get }
    func configure(for object: Any?)
}

extension BaseTableViewCell where Self: UITableViewCell {

    static func cellIdentifier() -> String {
        return String(describing: self)
    }

    static var height: CGFloat {
        get {
            return UITableView.automaticDimension
        }
    }

    func configure(for object: Any?) {

    }
}
