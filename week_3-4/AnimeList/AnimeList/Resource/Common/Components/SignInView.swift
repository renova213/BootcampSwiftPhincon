import UIKit
import RxSwift
import RxCocoa

protocol SignInViewDelegate: AnyObject {
    func didTapForgotPassword()
}

class SignInView: UIView {
    
    @IBOutlet weak var googleBorder: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let view = self.loadNib()
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func configureUI(){
        signInButton.roundCornersAll(radius: 20)
        googleBorder.layer.borderColor = UIColor.lightGray.cgColor
        googleBorder.layer.borderWidth = 0.5
        googleBorder.roundCornersAll(radius: 8)
        forgotPasswordButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        usernameField.addBottomBorderWithColor(color: UIColor.lightGray, thickness: 1, width: self.frame.width)
        usernameField.setPlaceholder(text: "Enter username", color: UIColor.lightGray)
        passwordField.addBottomBorderWithColor(color: UIColor.lightGray, thickness: 1, width: self.frame.width)
        passwordField.setPlaceholder(text: "Enter password", color: UIColor.lightGray)
    }
}
