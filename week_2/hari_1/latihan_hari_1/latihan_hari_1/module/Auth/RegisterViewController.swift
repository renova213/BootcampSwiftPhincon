//
//  RegisterViewController.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var telpField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerButton(_ sender: Any) {
        // Nonaktifkan tombol login dan tampilkan teks loading
        registerButton.isEnabled = false
        registerButton.setTitle("Memproses...", for: .normal)
        
        Task {
              
                    // Simulasikan penundaan 2 detik
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 detik
            
            displayAlert(title: "Register Sukses", message: "Silahkan login")
                
                // Aktifkan kembali tombol login dan kembalikan teksnya
                registerButton.isEnabled = true
                registerButton.setTitle("Login", for: .normal)
            }
    }
    
    func displayAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            registerButton.isEnabled = true
            registerButton.setTitle("Login", for: .normal)
        }

}
