import UIKit

class AnimeSection: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentAnimeCollection: UICollectionView!
    @IBOutlet weak var showButtonAll: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
    }
}

extension AnimeSection: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func configureTableView(){
        currentAnimeCollection.delegate = self
        currentAnimeCollection.dataSource = self
        currentAnimeCollection.registerCellWithNib(AnimeSectionItem.self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimeSectionItem", for: indexPath) as! AnimeSectionItem
        
        cell.setUpAnimeSection(title: "Jujutsu Kaisen 2nd Season", date: "Ditayangkan pada 16 j", urlImage: "https://m.media-amazon.com/images/M/MV5BMTMwMDM4N2EtOTJiYy00OTQ0LThlZDYtYWUwOWFlY2IxZGVjXkEyXkFqcGdeQXVyNjAwNDUxODI@._V1_.jpg", rating: 8.82 )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 280, height: 150)
    }

}
