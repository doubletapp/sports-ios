import Foundation
import UIKit

struct TableViewCellDescription {
    let cellType: BaseTableViewCell.Type
    var object: Any?
}

extension UITableView {

    func register<T: BaseTableViewCell>(_ classType: T.Type) {
        register(UINib(nibName: classType.cellIdentifier(), bundle: nil),
                forCellReuseIdentifier: classType.cellIdentifier())
    }

    func configureCell(with cellDescription: TableViewCellDescription, for indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: cellDescription.cellType.cellIdentifier(), for: indexPath)
        if let baseCell = cell as? BaseTableViewCell {
            baseCell.configure(for: cellDescription.object)
        }

        return cell
    }

    fileprivate var myRefreshControl: UIRefreshControl{
        let refreshControl = UIRefreshControl()
        return refreshControl
    }

    func addRefresh(_ actionHandler: (() -> Void)!) {

        actionHandleBlock(action: actionHandler)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(triggerActionHandleBlock), for: .valueChanged)
        self.refreshControl = refreshControl
    }

    @objc private func triggerActionHandleBlock() {
        self.actionHandleBlock()
    }

    private func actionHandleBlock(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }

}
