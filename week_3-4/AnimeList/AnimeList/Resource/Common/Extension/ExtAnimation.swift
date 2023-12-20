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

extension UILabel {
    func fadeIn(duration: TimeInterval = 1.0, completion: ((Bool) -> Void)? = nil) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOutAndIn(duration: TimeInterval = 1.0, delayBetween: TimeInterval = 1.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }) { (completed) in
            DispatchQueue.main.asyncAfter(deadline: .now() + delayBetween) {
                UIView.animate(withDuration: duration, animations: {
                    self.alpha = 1.0
                }, completion: completion)
            }
        }
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

extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.3) {
        self.alpha = 0.0
        self.isHidden = false
        UIView.animate(withDuration: duration) {
            self.alpha = 1.0
        }
    }
    
    func fadeOut(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }) { finished in
            self.isHidden = true
            self.alpha = 1.0
            completion?(finished)
        }
    }
}
