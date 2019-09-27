import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    class var shared: AppDelegate {
        // swiftlint:disable force_cast
        return UIApplication.shared.delegate as! AppDelegate
        // swiftlint:enable force_cast
    }

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

extension AppDelegate {
    
    func makeRoot(viewController: UIViewController?, animated: Bool = true) {
        guard let viewController = viewController else { return }
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        if let window = window {
            if animated {
                UIView.transition(
                    with: window,
                    duration: 0.3,
                    options: [.curveEaseInOut, .transitionCrossDissolve, .preferredFramesPerSecond60],
                    animations: { [weak window] in
                        window?.rootViewController = viewController
                        window?.makeKeyAndVisible()
                    }
                )
            } else {
                window.rootViewController = viewController
                window.makeKeyAndVisible()
            }
        }
    }
}


