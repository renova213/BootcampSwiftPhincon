import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var updatePasswordButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGesture()
    }
    
    private let disposeBag = DisposeBag()
    private var style = ToastStyle()
    
    func configureUI(){
        changePasswordView.roundCornersAll(radius: 10)
        changePasswordView.addShadow()
        updatePasswordButton.roundCornersAll(radius: 8)
        oldPassword.placeholder = "Enter old password"
        oldPassword.setHorizontalPadding(12)
        oldPassword.isSecureTextEntry = true
        newPassword.placeholder = "Enter new password"
        newPassword.setHorizontalPadding(12)
        newPassword.isSecureTextEntry = true
        style.backgroundColor = UIColor(named: "Main Color") ?? UIColor.black
        if let color = UIColor(named: "Main Color"){
            oldPassword.setBorderColor(color)
            oldPassword.roundCornersAll(radius: 10)
            newPassword.setBorderColor(color)
            newPassword.roundCornersAll(radius: 10)
        }
    }
    
    func configureGesture(){
        closeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false)
        }).disposed(by: disposeBag)
    }
}
