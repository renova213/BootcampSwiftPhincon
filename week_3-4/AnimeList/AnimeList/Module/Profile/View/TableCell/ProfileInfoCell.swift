import UIKit
import Kingfisher
import RxSwift
import RxCocoa

protocol ProfileInfoCellDelegate: AnyObject {
    func didTapNavigationSetting()
    func didTapGalleryImage()
}

class ProfileInfoCell: UITableViewCell {
    
    @IBOutlet weak var galleryButton: UIButton!
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
        joinedLabel.text = "Joined \(data.joinedDate ?? "")"
        birthdayLabel.text = data.birthday
        if let url = URL(string: data.image.urlImage){
            profileImage.kf.setImage(with: url, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
    
    func configureGesture(){
        settingButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.delegate?.didTapNavigationSetting()
        }).disposed(by: disposeBag)
        
        galleryButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.delegate?.didTapGalleryImage()
        }).disposed(by: disposeBag)
    }
}
