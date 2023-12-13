import Foundation
import UIKit

extension UIViewController {
    func presentSuccessPopUp(message: String, duration: TimeInterval = 3) {
        let vc = SuccessPopUp()
        vc.view.alpha = 0
        vc.setupMessage(message: message)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)

        UIView.animate(withDuration: 0.5) {
            vc.view.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.toDismissPopUp(vc)
        }
    }
    
    func presentFailedPopUp(message: String, duration: TimeInterval = 3) {
        let vc = FailedPopUp()
        
        vc.view.alpha = 0
        vc.setupMessage(message: message)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)

        UIView.animate(withDuration: 0.5) {
            vc.view.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.toDismissPopUp(vc)
        }
    }
    
    func toDismissPopUp(_ vc: UIViewController) {
        UIView.animate(withDuration: 0.5, animations: {
            vc.view.alpha = 0
        }) { _ in
            vc.dismiss(animated: true, completion: nil)
        }
    }
}
