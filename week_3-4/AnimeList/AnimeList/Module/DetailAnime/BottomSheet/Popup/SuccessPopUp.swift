import UIKit
import Lottie

class SuccessPopUp: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var successLottie: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successAnimate()
        configureUI()
    }
    
    func toDismissPopUp() {
        dismiss(animated: true, completion: nil)
    }
    
    func successAnimate() {
        successLottie.animation = LottieAnimation.named("success")
        successLottie.loopMode = .loop
        successLottie.play()    
    }
    
    func setupMessage(message: String){
        messageLabel.text = message
    }
    
    func configureUI(){
        popView.roundCornersAll(radius: 10)
        popView.addShadow()
    }
}
