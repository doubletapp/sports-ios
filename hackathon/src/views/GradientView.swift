import Foundation
import UIKit

enum GradientOrientation {
    case vertical
    case horizontal
}

class GradientView: UIView {
    var gradientLayer = CAGradientLayer()
    var startPoint = CGPoint(x: 0.5, y: 0)
    var endPoint = CGPoint(x: 0.5, y: 1.0)
    
    @IBInspectable var topColor: UIColor = UIColor.white {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = UIColor.black {
        didSet {
            updateUI()
        }
    }
    
    var orientation: GradientOrientation = .vertical
    
    override open class var layerClass: AnyClass { return CAGradientLayer.self }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateUI()
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        CATransaction.setDisableActions(true)
        gradientLayer.frame = bounds
        CATransaction.setDisableActions(false)
    }
    
    func updateUI() {
        setGradient()
    }
    
    func setGradient() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let startPoint = orientation == .vertical ? CGPoint(x: 0.5, y: 0) : CGPoint(x: 0, y: 0.5)
        let endPoint = orientation == .vertical ? CGPoint(x: 0.5, y: 1.0) : CGPoint(x: 1.0, y: 0.5)
        
        let gradientColors: [CGColor] = [topColor, bottomColor].compactMap { $0.cgColor }
        backgroundColor = .clear
        
        gradientLayer.frame = bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.contentsScale = UIScreen.main.scale
        gradientLayer.colors = gradientColors
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}
