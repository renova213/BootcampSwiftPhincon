//
//  ViewController.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    let authViewModel = AuthViewModel()
    let userViewModel = UserViewModel()
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var usernameFormField: InputField!
    @IBOutlet weak var passwordFormField: InputField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFormField()
        
    }
    
    func setUpFormField() {
        usernameFormField.setup(title: "Username", placeholder: "Masukkan Username")
        usernameFormField.errorLabel.isHidden = true
        
        passwordFormField.errorLabel.isHidden = true
        passwordFormField.setup(title: "Password", placeholder: "Masukkan Password")
        passwordFormField.textField.isSecureTextEntry = true
    }
    
    
    @IBAction func registerButton(_ sender: Any) {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginButton(_ sender: Any)  {
        loginButton.isEnabled = false
        
        let username = usernameFormField.textField.text ?? ""
        let password = passwordFormField.textField.text ?? ""
        
        let loginEntity = LoginEntity(username: username, password: password)
        
        authViewModel.loginUser(login: loginEntity) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                    // Handling success
                case .success(let loginResponse):
                    self.handleSuccessLogin(loginResponse)
                    // Handling failure
                case .failure(let error):
                    self.handleFailedLogin(with: error)
                }
            }
        }
    }
    
    func handleSuccessLogin(_ loginResponse: LoginResponse) {
        userViewModel.setUserFromLoginResponse(loginResponse: loginResponse)
        let username = userViewModel.getUser().username
        displayAlert(title: "Login Successful", message: "Welcome back\n\(username)", loginState: true)
    }
    
    func handleFailedLogin(with error: APIError) {
        displayAlert(title: "Login Failed", message: "\(error.message)", loginState: false)
    }
    
    func displayAlert(title: String, message: String, loginState: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.handleAlertAction(loginState)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func handleAlertAction(_ loginState: Bool) {
        if loginState {
            let vehicleVC = VehicleViewController()
            navigationController?.setViewControllers([vehicleVC], animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
        loginButton.isEnabled = true
        loginButton.setTitle("Login", for: .normal)
    }
}
