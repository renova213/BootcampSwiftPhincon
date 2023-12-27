import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class MangaDetailInfoCell: UITableViewCell {
    
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollection()
        configureUI()
    }
    
    private let disposeBag = DisposeBag()
    
    var mangaGenres:[DetailMangaGenre] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func configureUI(){
        imageContainer.layer.borderWidth = 1.0
        imageContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }
    
    func configureCollection(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellWithNib(MangaGenreItemCell.self)
    }
    
    func initialSetup(data: DetailMangaEntity){
        titleLabel.text = data.title ?? "-"
        typeLabel.text = data.type ?? "-"
        statusLabel.text = data.status ?? "-"
        synopsisLabel.text = data.synopsis ?? "-"
        
        
        if let imageURL = URL(string: data.images?.jpg?.imageURL ?? "") {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
        
        if let chapters = data.chapters {
            volumeLabel.text = "\(chapters) chapters"
        }else{
            volumeLabel.text = "-"
        }
        
        if let score = data.score {
            scoreLabel.text = String(score)
        }else{
            scoreLabel.text = "-"
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
            membersLabel.text = "#\(String(members))"
        }else{
            membersLabel.text = "-"
        }
        
        if let favorite = data.favorites {
            favoriteLabel.text = "#\(String(favorite))"
        }else{
            favoriteLabel.text = "-"
        }
        
        if let genreData = data.genres {
            mangaGenres = genreData
        }
    }
}

extension MangaDetailInfoCell: UICollectionViewDataSource, SkeletonCollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: MangaGenreItemCell.self)
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangaGenres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MangaGenreItemCell
        
            cell.initialSetup(genre: mangaGenres[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
            if indexPath.row < mangaGenres.count {
                label.text = mangaGenres[indexPath.row].name
            } else {
                label.text = ""
            }
            
            label.sizeToFit()
            let extraSpacing: CGFloat = 12
            
            return CGSize(width: label.frame.width + extraSpacing, height: 40)
    }
}
