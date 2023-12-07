import UIKit
import RxSwift
import RxCocoa

class ForgotPasswordPopUp: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private let disposeBag = DisposeBag()
    
    func configureUI(){
        confirmButton.roundCornersAll(radius: 8)
        emailField.setPlaceholder(text: "Enter email", color: UIColor.white)
    }
    func configureGesture(){
        closeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
}
