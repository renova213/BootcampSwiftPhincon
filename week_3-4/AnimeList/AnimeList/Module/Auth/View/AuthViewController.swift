import UIKit
import RxSwift
import RxCocoa
import Toast_Swift
import GoogleSignIn

class AuthViewController: UIViewController {
    
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var signUpView: SignUpView!
    @IBOutlet weak var signInView: SignInView!
    @IBOutlet weak var signUpToggleTitle: UILabel!
    @IBOutlet weak var signInToggleTitle: UILabel!
    @IBOutlet weak var toggleView: UIView!
    @IBOutlet weak var signUpToggleView: UIView!
    @IBOutlet weak var signInToggleView: UIView!
    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var authForm: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGesture()
        bindData()
    }
    
    private let disposeBag = DisposeBag()
    var style = ToastStyle()
    
    override func viewWillAppear(_ animated: Bool) {
        signUpView.isHidden = true
    }
    
    private func configureUI(){
        signInView.configureUI()
        
        signUpView.configureUI()
        
        loginImage.makeCircular()
        
        
        style.backgroundColor = UIColor(named: "Main Color") ?? UIColor.black
        authForm.roundCornersAll(radius: 20)
        authForm.addShadow()
        
        toggleView.roundCornersAll(radius: 20)
        toggleView.boxShadow(opacity: 0.2, offset: CGSize(width: 0, height: 0), shadowRadius: 3)
        
        signInToggleView.roundCornersAll(radius: 20)
        signUpToggleView.roundCornersAll(radius: 20)
        
        signInLabel.text = .localized("signIn")
        signUpLabel.text = .localized("signUp")
    }
    
    private func bindData(){
        AuthViewModel.shared.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .initial:
                break
            case .empty:
                break
            case .loading:
                self.signInView.signInButton.isEnabled = false
                self.signInView.googleBorder.isUserInteractionEnabled = false
                break
            case .finished:
                let vc = MainTabBarViewController()
                self.view.makeToast("Login success", duration: 2, style: self.style)
                DispatchQueue.main.asyncAfter(deadline: .now()+2){
                    self.signInView.signInButton.isEnabled = true
                    self.signInView.googleBorder.isUserInteractionEnabled = true
                    self.navigationController?.setViewControllers([vc], animated: true)
                    AuthViewModel.shared.loadingState.accept(.initial)
                }
                break
            case .failed:
                self.view.makeToast(AuthViewModel.shared.errorMessage.value, duration: 2, style: self.style)
                self.signInView.signInButton.isEnabled = true
                self.signInView.googleBorder.isUserInteractionEnabled = true
                break
            }
        }).disposed(by: disposeBag)
        
        AuthViewModel.shared.loadingState2.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            self.style.backgroundColor = UIColor(named: "Main Color") ?? UIColor.black
            
            switch state {
            case .loading:
                self.signUpView.signUpButton.isEnabled = false
                self.signUpView.googleBorder.isUserInteractionEnabled = false
                break
            case .initial:
                break
            case .empty:
                break
            case .finished:
                self.showSignInView()
                self.signUpView.usernameField.text = ""
                self.signUpView.emailField.text = ""
                self.signUpView.passwordField.text = ""
                self.view.makeToast("Register success", duration: 2, style: self.style)
                self.signUpView.signUpButton.isEnabled = true
                self.signUpView.googleBorder.isUserInteractionEnabled = true
                break
            case .failed:
                self.view.makeToast(AuthViewModel.shared.errorMessage.value, duration: 2, style: self.style)
                self.signUpView.signUpButton.isEnabled = true
                self.signUpView.googleBorder.isUserInteractionEnabled = true
                break
            }
        }).disposed(by: disposeBag)
    }
    
    private func configureGesture(){
        
        signUpView.googleBorder.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
                if let profileData = GIDSignIn.sharedInstance.currentUser?.profile {
                    AuthViewModel.shared.postData(for: Endpoint.postRegisterGoogle(params: RegisterGoogleParam(username: profileData.name, email: profileData.email)), resultType: RegisterResponse.self)
                }
            }
        }).disposed(by: disposeBag)
        
        signInView.googleBorder.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
                if let profileData = GIDSignIn.sharedInstance.currentUser?.profile {
                    AuthViewModel.shared.postData(for: Endpoint.postLoginGoogle(params: LoginGoogleParam(username: profileData.name, email: profileData.email)), resultType: LoginResponse.self)
                }
            }
        }).disposed(by: disposeBag)
        
        signUpToggleView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.showSignUpView()
        }).disposed(by: disposeBag)
        
        signInToggleView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.showSignInView()
        }).disposed(by: disposeBag)
        
        signInView.signInButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            AuthViewModel.shared.postData(for: Endpoint.postLogin(params: LoginParam(username: self.signInView.usernameField.text ?? "", password: self.signInView.passwordField.text ?? "")), resultType: LoginResponse.self)
        }).disposed(by: disposeBag)
        signUpView.signUpButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            AuthViewModel.shared.postData(for: Endpoint.postRegister(params: RegisterParam(username: self.signUpView.usernameField.text ?? "", email: self.signUpView.emailField.text ?? "", password: self.signUpView.passwordField.text ?? "")), resultType: RegisterResponse.self)
        }).disposed(by: disposeBag)
    }
    
    private func showSignInView(){
        UIView.animate(withDuration: 0.15) {
            self.signInToggleView.backgroundColor = UIColor(named: "Main Color")
            self.signUpToggleView.backgroundColor = UIColor.clear
            self.signInToggleTitle.textColor = UIColor.white
            self.signUpToggleTitle.textColor = UIColor(named: "Main Color")
            self.signUpView.isHidden = true
            self.signInView.isHidden = false
        }
    }
    
    private func showSignUpView(){
        UIView.animate(withDuration: 0.15) {
            self.signUpToggleView.backgroundColor = UIColor(named: "Main Color")
            self.signInToggleView.backgroundColor = UIColor.clear
            self.signUpToggleTitle.textColor = UIColor.white
            self.signInToggleTitle.textColor = UIColor(named: "Main Color")
            self.signUpView.isHidden = false
            self.signInView.isHidden = true
        }
    }
}
