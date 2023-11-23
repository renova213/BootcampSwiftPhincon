import Foundation
import UIKit

extension UIViewController {
    func presentBottomSheet(contentViewController: UIViewController) {
        let bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate()

        contentViewController.modalPresentationStyle = .custom
        contentViewController.transitioningDelegate = bottomSheetTransitioningDelegate

        present(contentViewController, animated: true, completion: nil)
    }
}
