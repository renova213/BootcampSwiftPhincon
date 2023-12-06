import Foundation
import UIKit

extension NSMutableAttributedString {
    func appendText(_ text: String, textColor: UIColor, font: UIFont) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: textColor,
            .font: font
        ]

        let appendedString = NSMutableAttributedString(string: text, attributes: attributes)
        self.append(appendedString)
    }
}
