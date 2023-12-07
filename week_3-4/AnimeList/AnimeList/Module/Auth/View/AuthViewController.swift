import UIKit
import RxSwift
import RxCocoa

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
    }
    
    private let disposeBag = DisposeBag()
    private let authVM = AuthViewModel()
    
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
    
    func configureGesture(){
        signUpToggleView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.15) {
                self.signUpToggleView.backgroundColor = UIColor(named: "Main Color")
                self.signInToggleView.backgroundColor = UIColor.clear
                self.signUpToggleTitle.textColor = UIColor.white
                self.signInToggleTitle.textColor = UIColor(named: "Main Color")
                self.signUpView.isHidden = false
                self.signInView.isHidden = true
            }
            
            self.authVM.switchAuthToggle(state: false)
        }).disposed(by: disposeBag)
        signInToggleView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.15) {
                self.signInToggleView.backgroundColor = UIColor(named: "Main Color")
                self.signUpToggleView.backgroundColor = UIColor.clear
                self.signInToggleTitle.textColor = UIColor.white
                self.signUpToggleTitle.textColor = UIColor(named: "Main Color")
                self.signUpView.isHidden = true
                self.signInView.isHidden = false
            }
        }).disposed(by: disposeBag)
    }
}
