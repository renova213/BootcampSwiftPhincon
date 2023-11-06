//
//  ViewController.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    let loginViewModel = LoginViewModel()
    let userViewModel = UserViewModel()
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailFormField: InputField!
    @IBOutlet weak var passwordFormField: InputField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpEmailFormField()
        setUpPasswordormField()
        
    }
    
    func setUpEmailFormField() {
        emailFormField.setup(title: "Email", placeholder: "Masukkan Email")
        emailFormField.errorLabel.isHidden = true
    }
    func setUpPasswordormField() {
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
        let username = emailFormField.textField.text ?? ""
        let password = passwordFormField.textField.text ?? ""
        
        loginViewModel.loginUser(username: username, password: password) { result in
            DispatchQueue.main.async {
                    print(result)
                switch result {
                case .success(let loginResponse):
                    // Handle successful login
                    self.userViewModel.setUserFromLoginResponse(loginResponse: loginResponse)
                    self.displayAlert(title: "Login Sukses", message: "Selamat datang kembali\n\(self.userViewModel.getUser().username)", loginState: true)
                    self.loginButton.isEnabled = true
                case .failure(let error):
                    // Handle login failure
                    self.displayAlert(title: "Login Gagal", message:"\(error.message)", loginState: false)
                    self.loginButton.isEnabled = true
                }
            }
        }
    }
    
    func displayAlert(title: String, message: String, loginState: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){_ in
            if(loginState){
                let vc = VehicleViewController()
                self.navigationController?.setViewControllers([vc], animated: true)
            }else{
                self.dismiss(animated: true)
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        loginButton.isEnabled = true
        loginButton.setTitle("Login", for: .normal)
    }
}
