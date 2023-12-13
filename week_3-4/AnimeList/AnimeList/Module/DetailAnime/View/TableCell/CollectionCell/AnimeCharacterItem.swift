import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxGesture

protocol AnimeCharacterItemDelegate: AnyObject {
    func didSelectCell(url: String)
}

class AnimeCharacterItem: UICollectionViewCell {
    @IBOutlet weak var favoriteCastButton: UIButton!
    @IBOutlet weak var favoriteCharacterButton: UIButton!
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
        configureUI()
        configureGesture()
    }
    
    var disposeBag = DisposeBag()
    weak var delegate: AnimeCharacterItemDelegate?
    var characterMalUrl:String?
    var voiceActorMalUrl: String?
}

extension AnimeCharacterItem {
    func configureUI(){
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
    
    func configureGesture(){
        characterView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }

                if let url = self.characterMalUrl{
                    self.delegate?.didSelectCell(url: url)
                }
            })
            .disposed(by: disposeBag)
        voiceActorView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }

                if let url = self.voiceActorMalUrl{
                    self.delegate?.didSelectCell(url: url)
                }
            })
            .disposed(by: disposeBag)
        favoriteCastButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
        }).disposed(by: disposeBag)
    }
}
