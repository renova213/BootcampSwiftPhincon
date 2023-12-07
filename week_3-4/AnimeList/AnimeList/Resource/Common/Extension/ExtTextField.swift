import Foundation
import UIKit

extension UITextField {
    func addBottomBorderWithColor(color: UIColor, thickness: CGFloat, width: CGFloat) {
        borderStyle = .none
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: frame.size.height - thickness, width: width, height: thickness)
        bottomBorder.backgroundColor = color.cgColor
        layer.addSublayer(bottomBorder)
    }
    
    func setPlaceholder(text: String, color: UIColor) {
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
}
