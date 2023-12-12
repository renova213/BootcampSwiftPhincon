import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

protocol UpdateProfileViewControllerDelegate: AnyObject {
    func didLoadUserData()
}

class UpdateProfileViewController: UIViewController {
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var updateProfileView: UIView!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGesture()
        bindData()
    }
    
    private let disposeBag = DisposeBag()
    private let datePicker = UIDatePicker()
    private let profileVM = ProfileViewModel()
    private var style = ToastStyle()
    weak var delegate: UpdateProfileViewControllerDelegate?
    
    func initialSetup(data: UserEntity){
        birthdayField.text = data.birthday
        usernameField.text = data.username
        emailField.text = data.email
    }
    
    func configureUI(){
        updateProfileView.roundCornersAll(radius: 10)
        updateProfileView.addShadow()
        updateButton.roundCornersAll(radius: 8)
        emailField.isEnabled = false
        emailField.placeholder = "Enter email"
        emailField.setHorizontalPadding(12)
        usernameField.placeholder = "Enter username"
        usernameField.setHorizontalPadding(12)
        birthdayField.placeholder = "Enter birthday"
        birthdayField.setHorizontalPadding(12)
        style.backgroundColor = UIColor(named: "Main Color") ?? UIColor.black
        if let color = UIColor(named: "Main Color"){
            emailField.setBorderColor(color)
            emailField.roundCornersAll(radius: 10)
            usernameField.setBorderColor(color)
            usernameField.roundCornersAll(radius: 10)
            birthdayField.setBorderColor(color)
            birthdayField.roundCornersAll(radius: 10)
        }
        usernameField.isEnabled = false
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 250)
        birthdayField.inputView = datePicker
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        let selectedDate = self.datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        let formattedDate = formatter.string(from: selectedDate)
        self.birthdayField.text = formattedDate
    }
    
    func configureGesture(){
        closeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false)
        }).disposed(by: disposeBag)
        
        updateButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let userId = self.profileVM.tokenHelper.getUserIDFromUserDefaults(){
                self.profileVM.loadData(for: Endpoint.putUser(params: UpdateUserParam(userId: userId, birthday: self.birthdayField.text ?? "-")), resultType: StatusResponse.self)
            }
        }).disposed(by: disposeBag)
    }
    
    func bindData(){
        profileVM.loadingState.subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                self.updateButton.isEnabled = false
            case .finished:
                self.view.makeToast("Data successfully updated", duration: 2, style: self.style)
                self.delegate?.didLoadUserData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    self.updateButton.isEnabled = true
                    self.dismiss(animated: true)
                }
            case .notLoad, .failed:
                if let errorMessage = self.profileVM.errorMessage.value?.message {
                    self.view.makeToast(errorMessage, duration: 2, style: self.style)
                }
                self.updateButton.isEnabled = true
            }
        }).disposed(by: disposeBag)
    }
}
