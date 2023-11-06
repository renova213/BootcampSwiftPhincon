//
//  InputField.swift
//  fuel_management_app
//
//  Created by Phincon on 31/10/23.
//

import UIKit

class InputField: UIView {
    
    @IBOutlet weak var uiViewTextField: UIView!
    @IBOutlet weak var labelField: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        let view = self.loadNib()
        view.frame = self.bounds
        view.backgroundColor = .white
        self.addSubview(view)
    }
    
    @IBAction func inputTapTextArea(_ sender: Any) {
        textField.becomeFirstResponder()
    }
    
    
    func setup(title: String = "", placeholder: String = "", error: String = "") {
        labelField.text = title
        textField.placeholder = placeholder
        errorLabel.text = error
        errorLabel?.tintColor = UIColor.red
    }
    
}
