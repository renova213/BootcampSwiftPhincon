//
//  RegisterViewController.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSetup()
        fieldSetup()
    }
    
    func buttonSetup(){
        registerButton.addTarget(self, action: #selector(registerTap), for: .touchUpInside)
    }
    
    func fieldSetup(){
        passwordField.isSecureTextEntry = true
        confirmPasswordField.isSecureTextEntry = true
    }
    
    @objc func registerTap() {
        // Nonaktifkan tombol login dan tampilkan teks loading
        registerButton.isEnabled = false
        
        Task {
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            
            guard let password = passwordField.text, !password.isEmpty else {
                displayAlert(title: "Register Gagal", message: "Password Kosong", registerState: false)
                return
            }
            
            guard let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty else {
                displayAlert(title: "Register Gagal", message: "Konfirmasi Password Kosong", registerState: false)
                return
            }
         
            
            Auth.auth().createUser(withEmail: emailField.text ?? "", password: passwordField.text ?? "") { authResult, error in
                if let error = error {
                    self.registerButton.isEnabled = true
                    self.displayAlert(title: "Register Gagal", message: error.localizedDescription, registerState: false)
                }else{
                    self.registerButton.isEnabled = true
                    self.displayAlert(title: "Register Berhasil", message: "Silahkan login", registerState: true)
                }
            }
        }
    }
    
    
    
    func displayAlert(title: String, message: String, registerState: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){_ in
            if(registerState){
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                self.dismiss(animated: true)
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        registerButton.isEnabled = true
        registerButton.setTitle("Login", for: .normal)
    }
    
}
