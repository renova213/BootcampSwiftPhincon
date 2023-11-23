import UIKit
import Lottie

class AddToListPopup: UIViewController {

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
        messageLabel.text = "Berhasil menambahkan ke dalam list"
        
        successLottie.play()    
    }
    
    func configureUI(){
        popView.roundCornersAll(radius: 10)
        popView.addShadow()
    }
}
