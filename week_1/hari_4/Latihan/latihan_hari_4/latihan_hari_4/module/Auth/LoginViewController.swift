//
//  ViewController.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func registerButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let destinationViewController = storyboard.instantiateViewController(withIdentifier: "registerScreen")
                self.navigationController?.pushViewController(destinationViewController, animated: true)
    }
    @IBAction func loginButton(_ sender: Any)  {
        // Nonaktifkan tombol login dan tampilkan teks loading
        loginButton.isEnabled = false
        loginButton.setTitle("Memproses...", for: .normal)
        
        Task {
              
                    // Simulasikan penundaan 2 detik
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 detik
                    
            guard let enteredUsername = usernameField.text, !enteredUsername.isEmpty else {
                        displayAlert(title: "Login Gagal", message: "Mohon isi username")
                        return
                    }

            guard let enteredPassword = passwordField.text, !enteredPassword.isEmpty else {
                        displayAlert(title: "Kesalahan", message: "Mohon isi password")
                        return
                    }
                    
            displayAlert(title: "Login Berhasil", message: "Selamat datang kembali")
            
            try await Task.sleep(nanoseconds: 1 * 1_000_000_000) // 1 detik
                    
                    // Jika login berhasil, navigasi ke layar berikutnya
                    self.performSegue(withIdentifier: "homeScreen", sender: nil)
              
                
                // Aktifkan kembali tombol login dan kembalikan teksnya
                loginButton.isEnabled = true
                loginButton.setTitle("Login", for: .normal)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
