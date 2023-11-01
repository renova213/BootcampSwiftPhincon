//
//  ViewController.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
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
        emailFormField.errorLabel.isHidden = true
        emailFormField.setup(title: "Email", placeholder: "Masukkan Email")
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
        
        Task {
            
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            
            Auth.auth().signIn(withEmail: emailFormField.textField.text ?? "", password: passwordFormField.textField.text ?? "") { authResult, error in
                if let error = error {
                    self.loginButton.isEnabled = true
                    self.displayAlert(title: "Login Gagal", message: error.localizedDescription, loginState: false)
                }else{
                    self.loginButton.isEnabled = true
                    self.displayAlert(title: "Login Berhasil", message: "Selamat datang kembali \(authResult!.user.email ?? "-")", loginState: true)
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
