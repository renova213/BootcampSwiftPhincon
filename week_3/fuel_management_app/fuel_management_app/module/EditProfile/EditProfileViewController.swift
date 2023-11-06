//
//  EditProfileViewController.swift
//  fuel_management_app
//
//  Created by Phincon on 01/11/23.
//

import UIKit

protocol EditProfileViewControllerDelegate: AnyObject{
    func passData(image:[UIImagePickerController.InfoKey : Any], user: UserEntity)
}

class EditProfileViewController: UIViewController {

    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var phoneField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var usernameField: InputField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setUpTextField()
    }
    
    let pickerImage = UIImagePickerController()
    var imageChoosen = [UIImagePickerController.InfoKey : Any]()
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    func setUpProfileView(){
        profileImage.makeRadius(withRadius: 10)
    }
    
    func setUpTextField(){
        phoneField.setup(title: "Nomor Telepon", placeholder: "Masukan Nomor Telepon")
        phoneField.errorLabel.isHidden = true
        emailField.setup(title: "Email", placeholder: "Masukan Email")
        emailField.errorLabel.isHidden = true
        usernameField.setup(title: "Name", placeholder: "Masukan Nama")
        usernameField.errorLabel.isHidden = true
    }
    
    func configureView(){
        galleryButton.addTarget(self, action: #selector(tapGallery), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(tapCamera), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(buttonPop), for: .touchUpInside)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    @objc func buttonPop() {
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    @objc func tapCamera(){
        self.pickerImage.allowsEditing = true
        self.pickerImage.delegate = self
        self.pickerImage.sourceType = .camera
        self.present(self.pickerImage, animated: true, completion: nil)
    }
    
    @objc func tapGallery(){
        self.pickerImage.allowsEditing = true
        self.pickerImage.delegate = self
        self.pickerImage.sourceType = .photoLibrary
        self.present(self.pickerImage, animated: true, completion: nil)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        self.profileImage.image = image
        self.imageChoosen = info
        self.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}

