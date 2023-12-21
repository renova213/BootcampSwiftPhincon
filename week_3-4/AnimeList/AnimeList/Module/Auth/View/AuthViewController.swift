import UIKit
import RxSwift
import RxCocoa
import Toast_Swift
import GoogleSignIn

class AuthViewController: UIViewController {
    
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
    private let authVM = AuthViewModel()
    var style = ToastStyle()
    
    override func viewWillAppear(_ animated: Bool) {
        signUpView.isHidden = true
    }
}

extension AuthViewController {
    
    func configureUI(){
        signInView.configureUI()
        
        signUpView.configureUI()
        
        loginImage.makeCircular()
        
        authForm.roundCornersAll(radius: 20)
        authForm.addShadow()
        
        toggleView.roundCornersAll(radius: 20)
        toggleView.boxShadow(opacity: 0.2, offset: CGSize(width: 0, height: 0), shadowRadius: 3)
        
        signInToggleView.roundCornersAll(radius: 20)
        signUpToggleView.roundCornersAll(radius: 20)
    }
    
    func bindData(){
        
        authVM.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            var style = ToastStyle()
            style.backgroundColor = UIColor(named: "Main Color") ?? UIColor.black
            
            switch state {
            case .loading:
                self.signInView.signInButton.isEnabled = false
                self.signInView.googleBorder.isUserInteractionEnabled = false
                break
            case .finished:
                let vc = MainTabBarViewController()
                self.view.makeToast("Login success", duration: 2, style: style)
                DispatchQueue.main.asyncAfter(deadline: .now()+2){
                    self.signInView.signInButton.isEnabled = true
                    self.signInView.googleBorder.isUserInteractionEnabled = true
                    self.navigationController?.setViewControllers([vc], animated: true)
                }
                break
            case .failed, .notLoad:
                if let errorMessage = self.authVM.errorMessage.value?.message {
                    self.view.makeToast(errorMessage, duration: 2, style: style)
                    self.signInView.signInButton.isEnabled = true
                    self.signInView.googleBorder.isUserInteractionEnabled = true
                }
                break
            }
        }).disposed(by: disposeBag)
        
        authVM.loadingState2.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            self.style.backgroundColor = UIColor(named: "Main Color") ?? UIColor.black
            
            switch state {
            case .loading:
                self.signUpView.signUpButton.isEnabled = false
                self.signUpView.googleBorder.isUserInteractionEnabled = false
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
            case .failed, .notLoad:
                if let errorMessage = self.authVM.errorMessage.value?.message {
                    self.view.makeToast(errorMessage, duration: 2, style: self.style)
                    self.signUpView.signUpButton.isEnabled = true
                    self.signUpView.googleBorder.isUserInteractionEnabled = true
                }
                break
            }
        }).disposed(by: disposeBag)
    }
    
    func configureGesture(){
        
        signUpView.googleBorder.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
                if let profileData = GIDSignIn.sharedInstance.currentUser?.profile {
                    self.authVM.postData(for: Endpoint.postRegisterGoogle(params: RegisterGoogleParam(username: profileData.name, email: profileData.email)), resultType: RegisterResponse.self)
                }
            }
        }).disposed(by: disposeBag)
        
        signInView.googleBorder.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
                if let profileData = GIDSignIn.sharedInstance.currentUser?.profile {
                    self.authVM.postData(for: Endpoint.postLoginGoogle(params: LoginGoogleParam(username: profileData.name, email: profileData.email)), resultType: LoginResponse.self)
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
            self.authVM.postData(for: Endpoint.postLogin(params: LoginParam(username: self.signInView.usernameField.text ?? "", password: self.signInView.passwordField.text ?? "")), resultType: LoginResponse.self)
        }).disposed(by: disposeBag)
        signUpView.signUpButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.authVM.postData(for: Endpoint.postRegister(params: RegisterParam(username: self.signUpView.usernameField.text ?? "", email: self.signUpView.emailField.text ?? "", password: self.signUpView.passwordField.text ?? "")), resultType: RegisterResponse.self)
        }).disposed(by: disposeBag)
    }
    
    func showSignInView(){
        UIView.animate(withDuration: 0.15) {
            self.signInToggleView.backgroundColor = UIColor(named: "Main Color")
            self.signUpToggleView.backgroundColor = UIColor.clear
            self.signInToggleTitle.textColor = UIColor.white
            self.signUpToggleTitle.textColor = UIColor(named: "Main Color")
            self.signUpView.isHidden = true
            self.signInView.isHidden = false
        }
    }
    
    func showSignUpView(){
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

