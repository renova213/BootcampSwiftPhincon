import UIKit
import RxSwift
import RxCocoa
import SkeletonView

protocol TodayAnimeDelegate: AnyObject {
    func didTapTodayAnime(malId: Int)
    func didTapNavigation()
}

class TodayAnime: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentAnimeCollection: UICollectionView!
    @IBOutlet weak var showMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
        tapMoreButton()
        configureComponentStyle()
    }
    
    private let disposeBag = DisposeBag()
    weak var delegate: TodayAnimeDelegate?
    var currentAnime: [AnimeEntity] = []{
        didSet{
            currentAnimeCollection.reloadData()
        }
    }
}


extension TodayAnime: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: TodayAnimeItem.self)
    }
    
    func configureTableView(){
        currentAnimeCollection.delegate = self
        currentAnimeCollection.dataSource = self
        currentAnimeCollection.registerCellWithNib(TodayAnimeItem.self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentAnime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = currentAnime[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayAnimeItem", for: indexPath) as! TodayAnimeItem
        
        cell.setUpComponent(title: data.title ?? "", date: "Ditayangkan pada pukul \(DateFormatter.convertTime(from: data.broadcast?.time ?? "00:00", fromTimeZone: data.broadcast?.timezone ?? "Asia/Tokyo", to: "Asia/Jakarta" ) ?? "-")", urlImage: data.images?.jpg?.imageUrl ?? "", rating: data.score )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 280, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = currentAnime[indexPath.row]
        
        delegate?.didTapTodayAnime(malId: data.malId ?? 0)
    }
}

extension TodayAnime {
    func tapMoreButton(){
        showMoreButton.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.didTapNavigation()
            })
            .disposed(by: disposeBag)
    }
    
    func configureComponentStyle(){
        showMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
}