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
        bindData()
    }
    
    private let disposeBag = DisposeBag()
    private var style = ToastStyle()
    private let profileVM = ProfileViewModel()
    
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
        
        updatePasswordButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults(){
                self.profileVM.updateData(for: Endpoint.putChangePassword(params: ChangePasswordParam(userId: userId, newPassword: self.newPassword.text ?? "", oldPassword: self.oldPassword.text ?? "")), resultType: StatusResponse.self
            )}
        }).disposed(by: disposeBag)
    }
    
    func bindData(){
        profileVM.loadingState.subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .initial:
                break
            case .empty:
                break
            case .loading:
                self.updatePasswordButton.isEnabled = false
            case .finished:
                self.view.makeToast("Password successfully updated", duration: 2, style: self.style)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    self.updatePasswordButton.isEnabled = true
                    self.dismiss(animated: true)
                }
            case .failed:
                self.view.makeToast(self.profileVM.errorMessage.value, duration: 2, style: self.style)
                self.updatePasswordButton.isEnabled = true
            }
        }).disposed(by: disposeBag)
    }
}
