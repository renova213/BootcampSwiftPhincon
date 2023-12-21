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
        bindData()
    }
    
    var disposeBag = DisposeBag()
    weak var delegate: AnimeCharacterItemDelegate?
    var characterMalUrl:String?
    var voiceActorMalUrl: String?
    var animeCharacter: AnimeCharacterEntity?
    private let detailAnimeVM = DetailAnimeViewModel()
    private let favoriteVM = FavoriteViewModel()
    
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
        animeCharacter = data
        characterMalUrl = data.character?.url
        favoriteVM.isExistFavoriteList(for: FavoriteEnum.animeCharacter(entity: data))
        favoriteVM.isExistFavoriteList(for: FavoriteEnum.animeCast(entity: data))
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
            if let animeCharacter = self.animeCharacter {
                self.favoriteVM.addToFavorite(for: FavoriteEnum.animeCast(entity: animeCharacter))
            }
        }).disposed(by: disposeBag)
        
        favoriteCharacterButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            if let animeCharacter = self.animeCharacter {
                self.favoriteVM.addToFavorite(for: FavoriteEnum.animeCharacter(entity: animeCharacter))
            }
        }).disposed(by: disposeBag)
    }
    
    func bindData(){
        favoriteVM.isExistAnimeCharacter.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            switch state {
            case true:
                self.favoriteCharacterButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            case false:
                self.favoriteCharacterButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }

            self.favoriteCharacterButton.bounceAnimation()
        }).disposed(by: disposeBag)
        
        favoriteVM.isExistAnimeCast.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case true:
                self.favoriteCastButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            case false:
                self.favoriteCastButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            self.favoriteCastButton.bounceAnimation()
        }).disposed(by: disposeBag)
    }
}
