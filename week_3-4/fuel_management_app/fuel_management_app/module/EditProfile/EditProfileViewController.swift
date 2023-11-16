import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var phoneField: InputField!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var usernameField: InputField!
    @IBOutlet weak var addressField: InputField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setUpUI()
    }
    
    
    var delegate: ProfileViewControllerDelegate?
    let pickerImage = UIImagePickerController()
    var imageChosen = [UIImagePickerController.InfoKey: Any]()
    
    @objc func buttonPop() {
        let email = emailField.textField.text ?? ""
        let address = addressField.textField.text ?? ""
        let phone = phoneField.textField.text ?? ""
        
        saveButton.isEnabled = false
        UserViewModel.shared.updateUser(email: email, phone: phone, address: address){ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    UserViewModel.shared.saveUserToUserDefaults(userData: data)
                    self.delegate?.passUserData(userData: data)
                    self.saveButton.isEnabled = true
                    self.navigationController?.popToRootViewController(animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @objc func tapCamera() {
        presentPicker(sourceType: .camera)
    }
    
    @objc func tapGallery() {
        presentPicker(sourceType: .photoLibrary)
    }
    
    func presentPicker(sourceType: UIImagePickerController.SourceType) {
        pickerImage.allowsEditing = true
        pickerImage.delegate = self
        pickerImage.sourceType = sourceType
        present(pickerImage, animated: true, completion: nil)
    }
}

extension EditProfileViewController {
    func setUpUI() {
        setUpProfileView()
        setUpTextFields()
    }
    
    func setUpProfileView() {
        profileImage.roundCornersAll(radius: 10)
    }
    
    func setUpTextFields() {
        let user = UserViewModel.shared.getUser()
        addressField.initialSetup(title: "Alamat", placeholder: "Masukan alamat", text: user.address)
        phoneField.initialSetup(title: "Nomor Telepon", placeholder: "Masukan nomor telepon", text: user.phone)
        emailField.initialSetup(title: "Email", placeholder: "Masukan email", text: user.email)
        usernameField.setupDisable(title: "Username", text: user.username)
    }
    
    func configureView() {
        galleryButton.addTarget(self, action: #selector(tapGallery), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(tapCamera), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(buttonPop), for: .touchUpInside)
        
        navigationItem.setHidesBackButton(true, animated: false)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        self.profileImage.image = image
        self.imageChosen = info
        self.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
