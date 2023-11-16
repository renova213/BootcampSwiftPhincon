//
//  RegisterViewController.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class RegisterViewController: UIViewController {
    let authViewModel = AuthViewModel()
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var usernameFormField: InputField!
    @IBOutlet weak var emailFormField: InputField!
    @IBOutlet weak var passwordFormField: InputField!
    @IBOutlet weak var confirmPasswordFormField: InputField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
        setUpFormField()
    }
    
    func setUpFormField() {
        usernameFormField.setup(title: "Username", placeholder: "Masukkan Username")
        usernameFormField.errorLabel.isHidden = true
        
        emailFormField.setup(title: "Email", placeholder: "Masukkan Email")
        emailFormField.errorLabel.isHidden = true
        
        passwordFormField.errorLabel.isHidden = true
        passwordFormField.setup(title: "Password", placeholder: "Masukkan Password")
        passwordFormField.textField.isSecureTextEntry = true
        
        confirmPasswordFormField.errorLabel.isHidden = true
        confirmPasswordFormField.setup(title: "Konfirmasi Password", placeholder: "Masukkan Password Kembali")
        confirmPasswordFormField.textField.isSecureTextEntry = true
    }
    
    
    
    func buttonSetup(){
        registerButton.addTarget(self, action: #selector(registerTap), for: .touchUpInside)
    }
    
    
    @objc func registerTap() {
        registerButton.isEnabled = false
        
        let username = usernameFormField.textField.text ?? ""
        let email = emailFormField.textField.text ?? ""
        let password = passwordFormField.textField.text ?? ""
        let confirmPassword = confirmPasswordFormField.textField.text ?? ""
        
        authViewModel.registerUser(register: RegisterEntity(username: username, email:email, password: password, confirmPassword: confirmPassword)) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success:
                    self.handleSuccessRegister()
                case .failure(let error):
                    self.handleFailedRegister(with: error)
                }
            }
        }
    }
    
    func handleSuccessRegister() {
        displayAlert(title: "Register Successful", message: "Silahkan login", registerState: true)
    }
    
    func handleFailedRegister(with error: APIError) {
        displayAlert(title: "Register Gagal", message: "\(error.message)", registerState: false)
    }
    
    func displayAlert(title: String, message: String, registerState: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.handleAlertAction(registerState)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func handleAlertAction(_ registerState: Bool) {
        if registerState {
            let loginVC = LoginViewController()
            navigationController?.setViewControllers([loginVC], animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
        registerButton.isEnabled = true
        registerButton.setTitle("Register", for: .normal)
    }
}
