import Foundation
import UIKit

extension Error {
    var code: ErrorCode { return ErrorCode(rawValue: (self as NSError).code) ?? .unknownError }
    var domain: String { return (self as NSError).domain }
}

enum ErrorCode: Int {
    case unknownError = -999
    case internetConnection = -1009
}

func makeError(with message: String) -> Error {
    return NSError(domain: "", code: ErrorCode.unknownError.rawValue, userInfo: [
        NSLocalizedDescriptionKey: message
        ])
}

func showError(message: String, viewController: UIViewController?, completion: @escaping () -> Void = {}) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
        completion()
    })
    if let viewController = viewController {
        viewController.present(alert, animated: true)
    } else {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController!.present(alert, animated: true)
    }
}

func showError(message: String, positiveButton: String, negativeButton: String, viewController: UIViewController?, completion: @escaping (_ poitive: Bool, _ negative: Bool) -> Void) {
    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: negativeButton, style: .default) { _ in
        completion(false, true)
    })
    alert.addAction(UIAlertAction(title: positiveButton, style: .default) { _ in
        completion(true, false
        )
    })
    if let viewController = viewController {
        viewController.present(alert, animated: true)
    } else {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController!.present(alert, animated: true)
    }
}
