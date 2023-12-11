import UIKit
import RxSwift
import RxCocoa

class UpdateProfileViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var updateProfileView: UIView!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGesture()
    }
    
    private let disposeBag = DisposeBag()
    
    func initialSetup(data: UserEntity){
        birthdayField.text = data.birthday
        usernameField.text = data.username
        emailField.text = data.email
    }
    
    func configureUI(){
        updateProfileView.roundCornersAll(radius: 10)
        updateProfileView.addShadow()
        updateButton.roundCornersAll(radius: 8)
        emailField.isEnabled = false
        emailField.placeholder = "Enter email"
        usernameField.placeholder = "Enter username"
        birthdayField.placeholder = "Enter birthday"
        if let color = UIColor(named: "Main Color"){
            emailField.setBorderColor(color)
            usernameField.setBorderColor(color)
            birthdayField.setBorderColor(color)
        }
        usernameField.isEnabled = false
        birthdayField.isUserInteractionEnabled = false
    }
    
    func configureGesture(){
        closeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false)
        }).disposed(by: disposeBag)
    }
}
