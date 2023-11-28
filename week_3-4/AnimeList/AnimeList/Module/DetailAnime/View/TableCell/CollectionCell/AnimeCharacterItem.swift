import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxGesture

protocol AnimeCharacterItemDelegate: AnyObject {
    func didSelectCell(url: String)
}

class AnimeCharacterItem: UICollectionViewCell {
    @IBOutlet weak var animeCharacterImage: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var voiceActorImage: UIImageView!
    @IBOutlet weak var voiceActorNameLabel: UILabel!
    @IBOutlet weak var voiceActorNameView: UIView!
    @IBOutlet weak var animeCharacterView: UIView!
    @IBOutlet weak var voiceActorView: UIView!
    @IBOutlet weak var characterView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponentStyle()
        configureComponentGesture()
    }
    
    var disposeBag = DisposeBag()
    weak var delegate: AnimeCharacterItemDelegate?
    var characterMalUrl:String?
    var voiceActorMalUrl: String?
}

extension AnimeCharacterItem {
    func configureComponentStyle(){
        voiceActorNameView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        animeCharacterView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    func initialSetup(data: AnimeCharacterEntity){
        characterNameLabel.text = data.character?.name ?? "-"
        if let voiceActors = data.voiceActors?.first{
            voiceActorNameLabel.text = voiceActors.person?.name ?? ""
            voiceActorMalUrl = voiceActors.person?.url
            
            if let voiceActorImageURL = URL(string: voiceActors.person?.images?.jpg?.imageURL ?? "") {
                self.voiceActorImage.kf.setImage(with: voiceActorImageURL, placeholder: UIImage(named: "ImagePlaceholder"))
            }
        }
        
        if let characterImageURL = URL(string: data.character?.images?.jpg?.imageURL ?? "") {
            self.animeCharacterImage.kf.setImage(with: characterImageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
        
        characterMalUrl = data.character?.url
    }
    
    func configureComponentGesture(){
        characterView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                if let url = self?.characterMalUrl{
                    self?.delegate?.didSelectCell(url: url)
                }
            })
            .disposed(by: disposeBag)
        voiceActorView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                if let url = self?.voiceActorMalUrl{
                    self?.delegate?.didSelectCell(url: url)
                }
            })
            .disposed(by: disposeBag)
    }
}
