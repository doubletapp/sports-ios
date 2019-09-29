import Foundation
import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int, alphaValue: Double) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alphaValue))
    }

    convenience init(netHex: Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff, alphaValue: 1.0)
    }

    convenience init(hexString: String?) {
        guard let guardString: String = hexString else { self.init(); return }
        var cString:String = guardString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            self.init()
            return
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
        )
    }

    convenience init(netHex: Int, alpha: Double) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff, alphaValue: alpha)
    }

    static func imageFromColor(_ color: UIColor) -> UIImage
    {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

}

extension UIColor {

    open class var primaryRed: UIColor {
        return UIColor(netHex: 0xF66262)
    }
    
    open class var primaryBlue: UIColor {
        return UIColor(netHex: 0x0199EA)
    }

    open class var darkGray: UIColor {
        return UIColor(netHex: 0x2F2F2F)
    }

    open class var lightGray: UIColor {
        return UIColor(netHex: 0xFFFFFF, alpha: 0.3)
    }
    
    open class var backgroundGray: UIColor {
        return UIColor(netHex: 0xF9F9F9)
    }
}

