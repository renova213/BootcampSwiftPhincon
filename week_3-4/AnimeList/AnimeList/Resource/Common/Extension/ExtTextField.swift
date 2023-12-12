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
    
    func setBorderColor(_ color: UIColor, width: CGFloat = 1.0, cornerRadius: CGFloat = 0.0) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = cornerRadius > 0.0
    }
    
    func setHorizontalPadding(_ horizontal: CGFloat) {
        let paddingLeftView = UIView(frame: CGRect(x: 0, y: 0, width: horizontal, height: frame.size.height))
        leftView = paddingLeftView
        leftViewMode = .always
        
        let paddingRightView = UIView(frame: CGRect(x: 0, y: 0, width: horizontal, height: frame.size.height))
        rightView = paddingRightView
        rightViewMode = .always
    }
}
