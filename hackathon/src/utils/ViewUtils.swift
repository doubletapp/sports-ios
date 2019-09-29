import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var borderColor: UIColor {
        set(newValue) {
            layer.borderColor = newValue.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return .clear
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set(newValue) {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        set(newValue) {
            layer.masksToBounds = false
            layer.shadowColor = newValue.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return .clear
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        set(newValue) {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        set(newValue) {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set(newValue) {
            layer.shadowOpacity = newValue / 100.0
        }
        get {
            return layer.shadowOpacity * 100.0
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set(newValue) {
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    func showLoading() {
        let loaderView = LoaderView()
        loaderView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(loaderView)

        loaderView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        loaderView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        loaderView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        loaderView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        loaderView.alpha = 0

        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: .transitionCrossDissolve,
            animations: {
                loaderView.alpha = 1.0
            },
            completion: nil
        )
    }

    func hideLoading() {
        for subview in subviews {
            if let loader = subview as? LoaderView {
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0.0,
                    options: .transitionCrossDissolve,
                    animations: {
                        loader.alpha = 0.0
                    },
                    completion: { result in
                        loader.removeFromSuperview()
                    }
                )
            }
        }
    }
    
}
