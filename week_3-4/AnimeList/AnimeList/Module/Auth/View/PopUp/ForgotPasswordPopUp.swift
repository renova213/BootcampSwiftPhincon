import UIKit
import RxSwift
import RxCocoa

class ForgotPasswordPopUp: UIViewController {
    
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGesture()
    }
    
    private let disposeBag = DisposeBag()
    
    func configureUI(){
        confirmButton.roundCornersAll(radius: 10)
        emailField.setPlaceholder(text: "Enter email", color: UIColor.white)
        emailField.textColor = UIColor.white
        emailField.addBottomBorderWithColor(color: UIColor.white, thickness: 1, width: emailField.frame.size.width)
        forgotPasswordView.roundCornersAll(radius: 20)
        forgotPasswordView.addShadow()
    }
    
    func configureGesture(){
        closeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.dismiss(animated: false)
        }).disposed(by: disposeBag)
    }
}
