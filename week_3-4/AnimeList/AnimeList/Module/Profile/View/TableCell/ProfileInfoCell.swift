import UIKit
import Kingfisher
import RxSwift
import RxCocoa

protocol ProfileInfoCellDelegate: AnyObject {
    func didTapNavigationSetting()
}

class ProfileInfoCell: UITableViewCell {
    
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureGesture()
    }
    
    weak var delegate: ProfileInfoCellDelegate?
    private let disposeBag = DisposeBag()
    
    func initialSetup(data: UserEntity){
        nameLabel.text = data.username
        joinedLabel.text = data.joinedDate
        birthdayLabel.text = data.birthday
    }
    
    func configureGesture(){
        settingButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.delegate?.didTapNavigationSetting()
        }).disposed(by: disposeBag)
    }
}
