import UIKit
import RxSwift
import RxCocoa

protocol SignInViewDelegate: AnyObject {
    func didTapForgotPassword()
}

class SignInView: UIView {
    
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var googleBorder: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
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
    
    let eyeButton = UIButton(type: .custom)
    
    func configureUI(){
        signInButton.roundCornersAll(radius: 20)
        
        googleBorder.layer.borderColor = UIColor.lightGray.cgColor
        googleBorder.layer.borderWidth = 0.5
        googleBorder.roundCornersAll(radius: 8)
        
        orLabel.text = .localized("or")
                
        usernameField.addBottomBorderWithColor(color: UIColor.lightGray, thickness: 1, width: self.frame.width)
        usernameField.setPlaceholder(text: .localized("usernameHintField"), color: UIColor.lightGray)
        usernameField.isUserInteractionEnabled = true
            usernameField.keyboardType = .default
        
        passwordField.addBottomBorderWithColor(color: UIColor.lightGray, thickness: 1, width: self.frame.width)
        passwordField.setPlaceholder(text: .localized("passwordHintField"), color: UIColor.lightGray)
        passwordField.isSecureTextEntry = true
        
        signInButton.setTitle(.localized("signIn"), for: .normal)
        signInButton.setTitle(.localized("signIn"), for: .disabled)
    }
}
