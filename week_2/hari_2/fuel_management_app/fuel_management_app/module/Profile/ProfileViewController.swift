//
//  ProfileViewController.swift
//  latihan_hari_1
//
//  Created by Phincon on 30/10/23.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var EditProfileButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logout: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfileView()
        setUpGesture()
    }
    
    func setUpProfileView(){
        imageProfile.makeRounded()
    }
    
    func setUpGesture(){
        let logoutGesture = UITapGestureRecognizer(target: self, action: #selector(logoutTapped))
        logout.addGestureRecognizer(logoutGesture)
        logout.isUserInteractionEnabled = true
    }
    
    @IBAction func editProfileTapped(_ sender: Any) {
        let vc = EditProfileViewController()
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logoutTapped() {
        do {
            try Auth.auth().signOut()
            let vc = LoginViewController()
            
            navigationController?.setViewControllers([vc], animated: true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension ProfileViewController: EditProfileViewControllerDelegate {
    func passData(image: [UIImagePickerController.InfoKey : Any], phone: String, email: String) {
        guard let image = image[.editedImage]as? UIImage else { return }
        
        imageProfile.image = image
        phoneLabel.text = phone
        emailLabel.text = email
    }
}
