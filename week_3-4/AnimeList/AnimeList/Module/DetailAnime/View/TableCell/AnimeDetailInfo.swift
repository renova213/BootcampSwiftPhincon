import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class AnimeDetailInfo: UITableViewCell {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var imageBorderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        configureCollection()
    }
    
    var fullDescription = ""
    var isExpanded = BehaviorRelay<Bool>(value: false)
    let disposeBag = DisposeBag()
    var animeGenre:[AnimeDetailGenre]? {
        didSet {
            genreCollectionView.reloadData()
        }
    }
    
    func configureUI(){
        imageBorderView.layer.borderWidth = 1.0
        imageBorderView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }
    
    func initialSetup(data: AnimeDetailEntity){
        titleLabel.text = data.title ?? "-"
        
        statusLabel.text = data.status ?? "-"
        
        durationLabel.text = data.duration ?? "-"
        
        if let imageURL = URL(string: data.images?.jpg?.imageUrl ?? "") {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
        
        if let releaseYear = data.aired?.prop?.from?.year{
            releaseDateLabel.text = String(releaseYear)
        }
        
        if let score = data.score {
            scoreLabel.text = String(score)
        }else{
            scoreLabel.text = "-"
        }
        
        if let synopsis = data.synopsis {
            synopsisLabel.text = synopsis
        }else{
            synopsisLabel.text = "-"
        }
        
        if let rank = data.rank {
            rankLabel.text = "#\(String(rank))"
        }else{
            rankLabel.text = "-"
        }
        
        if let popularity = data.popularity {
            popularityLabel.text = "#\(String(popularity))"
        }else{
            popularityLabel.text = "-"
        }
        
        if let members = data.members {
            membersLabel.text = String(members)
        }else{
            membersLabel.text = "-"
        }
        
        if let favorite = data.favorites {
            favoriteLabel.text = String(favorite)
        }else{
            favoriteLabel.text = "-"
        }
        
        if let genreData = data.genres {
            animeGenre = genreData
        }
    }
}

extension AnimeDetailInfo: SkeletonCollectionViewDataSource, SkeletonCollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: AnimeGenreItem.self)
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func configureCollection(){
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        genreCollectionView.registerCellWithNib(AnimeGenreItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animeGenre?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimeGenreItem", for: indexPath) as! AnimeGenreItem
        
        if let data = animeGenre{
            cell.initialSetup(genre: data[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        if let data = animeGenre{
            if indexPath.row < data.count {
                label.text = data[indexPath.row].name
            } else {
                label.text = ""
            }
            
            label.sizeToFit()
            let extraSpacing: CGFloat = 12
            
            return CGSize(width: label.frame.width + extraSpacing, height: 40)
        }
        
        return CGSize(width: 70, height: 40)
    }
}
