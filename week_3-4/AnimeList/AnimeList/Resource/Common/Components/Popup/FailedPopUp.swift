import UIKit
import Lottie


class FailedPopUp: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var failedLottie: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        failedAnimated()
        configureUI()
    }
    
    func toDismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
    
    func failedAnimated() {
        failedLottie.animation = LottieAnimation.named("failed")
        failedLottie.loopMode = .loop
        
        failedLottie.play()
    }
    
    func setupMessage(message: String){
        messageLabel.text = message
    }

    func configureUI(){
        popView.roundCornersAll(radius: 10)
        popView.addShadow()
    }
}
