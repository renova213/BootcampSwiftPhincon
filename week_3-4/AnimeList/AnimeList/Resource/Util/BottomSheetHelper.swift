import Foundation
import UIKit

class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class BottomSheetPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let frame = CGRect(x: 0,
                           y: containerView!.bounds.height - presentedView!.frame.height,
                           width: containerView!.bounds.width,
                           height: presentedView!.frame.height)
        return frame
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
    }
}
