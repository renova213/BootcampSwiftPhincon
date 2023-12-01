import Foundation
import UIKit

extension UICollectionViewCell {
    func rotate360Degrees(duration: TimeInterval = 1.0) {
        self.transform = CGAffineTransform(rotationAngle: .pi)
        UIView.animate(withDuration: duration, animations: {
            self.transform = .identity
        })
    }
    func bounceAnimation(scaleX: CGFloat = 0.001, scaleY: CGFloat = 0.001, duration: TimeInterval = 0.8) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5,
                       options: .allowUserInteraction,
                       animations: {
            self.transform = .identity
        },
                       completion: nil)
    }
}

extension UIButton {
    func bounceAnimation(scaleX: CGFloat = 0.001, scaleY: CGFloat = 0.001, duration: TimeInterval = 0.8) {
        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 5,
                       options: .allowUserInteraction,
                       animations: {
                           self.transform = .identity
                       },
                       completion: nil)
    }
}
