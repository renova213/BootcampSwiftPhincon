//
//  EditProfileViewController.swift
//  fuel_management_app
//
//  Created by Phincon on 01/11/23.
//

import UIKit

protocol EditProfileViewControllerDelegate: AnyObject{
    func passData(image:[UIImagePickerController.InfoKey : Any], phone: String, email: String)
}

class EditProfileViewController: UIViewController {

    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
    }
    
    let pickerImage = UIImagePickerController()
    var imageChoosen = [UIImagePickerController.InfoKey : Any]()
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    func setUpProfileView(){
        profileImage.makeRadius(withRadius: 10)
    }
    
    func configureView(){
        galleryButton.addTarget(self, action: #selector(tapGallery), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(tapCamera), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(buttonPop), for: .touchUpInside)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    
    @objc func buttonPop() {
        delegate?.passData(image: imageChoosen, phone: "2414224", email: "a@acom")
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
