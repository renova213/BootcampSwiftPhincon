//
//  ViewController.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit

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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "registerScreen")
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    @IBAction func loginButton(_ sender: Any)  {
        // Nonaktifkan tombol login dan tampilkan teks loading
        loginButton.isEnabled = false
        
        Task {
            
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            
            guard let enteredEmail = emailFormField.textField.text, !enteredEmail.isEmpty else {
                displayAlert(title: "Login Gagal", message: "Mohon isi email")
                return
            }
            
            guard let enteredPassword = passwordFormField.textField.text, !enteredPassword.isEmpty else {
                displayAlert(title: "Kesalahan", message: "Mohon isi password")
                return
            }
            
            if !isValidEmail(enteredEmail) {
                   displayAlert(title: "Login Gagal", message: "Format email tidak valid")
                   return
               }
            
            displayAlert(title: "Login Berhasil", message: "Selamat datang kembali")
            
            try await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            
            let vc = VehicleViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
            
            loginButton.isEnabled = true
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        loginButton.isEnabled = true
        loginButton.setTitle("Login", for: .normal)
        
    }
}
