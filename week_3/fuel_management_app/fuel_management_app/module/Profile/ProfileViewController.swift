import UIKit
import FirebaseAuth

protocol ProfileViewControllerDelegate{
    func passUserData(userData: UserEntity)
}

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var EditProfileButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logout: UIStackView!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setUp()
    }
    
    @IBAction func editProfileTapped(_ sender: Any) {
        
        let vc = EditProfileViewController()
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logoutTapped() {
        let vc = LoginViewController()
        navigationController?.setViewControllers([vc], animated: true)
    }
}

extension ProfileViewController: ProfileViewControllerDelegate {
    func passUserData(userData: UserEntity) {
        usernameLabel.text = userData.username
        phoneLabel.text = userData.phone
        emailLabel.text = userData.email
        addressLabel.text = userData.address
    }
}

extension ProfileViewController {
    func setUp(){
        func setUpProfileView(){
            imageProfile.makeRounded()
        }
        
        func setUpGesture(){
            let logoutGesture = UITapGestureRecognizer(target: self, action: #selector(logoutTapped))
            logout.addGestureRecognizer(logoutGesture)
            logout.isUserInteractionEnabled = true
        }
    }
}

extension ProfileViewController {
    func fetchUser(){
        UserViewModel.shared.fetchUserByUsername()
        let user = UserViewModel.shared.getUser()
        usernameLabel.text = user.username
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        addressLabel.text = user.address
    }
}
