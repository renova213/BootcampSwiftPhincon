import UIKit

class TodayAnime: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentAnimeCollection: UICollectionView!
    @IBOutlet weak var showButtonAll: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
    }
    
    var currentAnime: [AnimeEntity] = []{
        didSet{
            currentAnimeCollection.reloadData()
        }
    }
}


extension TodayAnime: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        
        cell.setUpComponent(title: data.title ?? "", date: "Ditayangkan pada pukul \(AnimeViewModel.shared.convertTime(from: data.broadcast?.time ?? "00:00", fromTimeZone: data.broadcast?.timezone ?? "Asia/Tokyo", to: "Asia/Jakarta" ) ?? "-")", urlImage: data.images?.jpg?.imageUrl ?? "", rating: data.score ?? 0.0 )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 280, height: 150)
    }
    
}
