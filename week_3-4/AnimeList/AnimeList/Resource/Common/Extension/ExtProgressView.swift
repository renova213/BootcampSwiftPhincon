import Foundation
import UIKit

extension UIProgressView {

    @IBInspectable var barHeight : CGFloat {
        get {
            return transform.d * 2.0
        }
        set {
            let heightScale = newValue / 2.0
            let c = center
            transform = CGAffineTransformMakeScale(1.0, heightScale)
            center = c
        }
    }
}
