import UIKit
import RxSwift
import RxCocoa

protocol ProfileFavoriteCellDegelate: AnyObject {
    func minimizeFavorite()
}

class ProfileFavoriteCell: UITableViewCell {
    
    @IBOutlet weak var minimizeStack: UIStackView!
    @IBOutlet weak var profileFavoriteView: UIView!
    @IBOutlet weak var characterCollection: UICollectionView!
    @IBOutlet weak var castCollection: UICollectionView!
    @IBOutlet weak var mangaCollection: UICollectionView!
    @IBOutlet weak var animeCollection: UICollectionView!
    @IBOutlet weak var chevronButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollection()
        configureUI()
        configureGesture()
    }
    
    weak var delegate: ProfileFavoriteCellDegelate?
    var favoriteAnimeList: [FavoriteAnimeEntity] = [] {
        didSet {
            animeCollection.reloadData()
        }
    }
    var favoriteAnimeCharacter: [FavoriteAnimeCharacterEntity] = [] {
        didSet {
            characterCollection.reloadData()
        }
    }
    private let disposeBag = DisposeBag()
}

extension ProfileFavoriteCell {
    func configureGesture(){
        chevronButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.delegate?.minimizeFavorite()
        }).disposed(by: disposeBag)
    }
    
    func configureUI(){
        profileFavoriteView.roundCornersAll(radius: 8)
    }
    
    func configureCollection(){
        mangaCollection.delegate = self
        mangaCollection.dataSource = self
        mangaCollection.registerCellWithNib(ProfileFavoriteItemCell.self)
        
        animeCollection.delegate = self
        animeCollection.dataSource = self
        animeCollection.registerCellWithNib(ProfileFavoriteItemCell.self)
        
        characterCollection.delegate = self
        characterCollection.dataSource = self
        characterCollection.registerCellWithNib(ProfileFavoriteItemCell.self)
        
        castCollection.delegate = self
        castCollection.dataSource = self
        castCollection.registerCellWithNib(ProfileFavoriteItemCell.self)
    }
    
    func initialChevronButton(state: Bool){
        switch state {
        case true:
            chevronButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            minimizeStack.isHidden = true
        case false:
            chevronButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            minimizeStack.isHidden = false
        }
    }
}

extension ProfileFavoriteCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch  collectionView{
        case animeCollection:
            return favoriteAnimeList.count
        case mangaCollection:
            return 5
        case characterCollection:
            return favoriteAnimeCharacter.count
        case castCollection:
            return 2
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ProfileFavoriteItemCell
        switch collectionView {
        case animeCollection:
            let data = favoriteAnimeList[indexPath.row]
            cell.initialSetup(title: data.title ?? "", urlImage: data.urlImage ?? "")
            break
        case mangaCollection:
            break
        case characterCollection:
            let data = favoriteAnimeCharacter[indexPath.row]
            cell.initialSetup(title: data.name ?? "", urlImage: data.urlImage ?? "")
            break
        case castCollection:
            break
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 160)
    }
}
