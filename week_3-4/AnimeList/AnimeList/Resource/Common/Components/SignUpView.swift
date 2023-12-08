import Foundation
import UIKit

class SignUpView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var googleBorder: UIView!
    @IBOutlet weak var signUpButton: UIButton!
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
        signUpButton.roundCornersAll(radius: 20)
        
        googleBorder.layer.borderColor = UIColor.lightGray.cgColor
        googleBorder.layer.borderWidth = 0.5
        googleBorder.roundCornersAll(radius: 8)
        
        usernameField.addBottomBorderWithColor(color: UIColor.lightGray, thickness: 1, width: self.frame.width)
        usernameField.setPlaceholder(text: "Enter username", color: UIColor.lightGray)
        
        passwordField.addBottomBorderWithColor(color: UIColor.lightGray, thickness: 1, width: self.frame.width)
        passwordField.setPlaceholder(text: "Enter password", color: UIColor.lightGray)
        passwordField.isSecureTextEntry = true
        
        emailField.addBottomBorderWithColor(color: UIColor.lightGray, thickness: 1, width: self.frame.width)
        emailField.setPlaceholder(text: "Enter email", color: UIColor.lightGray)
    }
}
