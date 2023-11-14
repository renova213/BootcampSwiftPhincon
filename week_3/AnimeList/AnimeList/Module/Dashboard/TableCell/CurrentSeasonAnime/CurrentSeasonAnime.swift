import UIKit

class CurrentSeasonAnime: UITableViewCell {

    @IBOutlet weak var animeCategoryCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    var currentSeasonAnime: [AnimeEntity] = []{
        didSet{
            animeCategoryCollection.reloadData()
        }
    }
}

extension CurrentSeasonAnime: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureCollectionView(){
        animeCategoryCollection.delegate = self
        animeCategoryCollection.dataSource = self
        animeCategoryCollection.registerCellWithNib(CurrentSeasonAnimeItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentSeasonAnime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = currentSeasonAnime[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CurrentSeasonAnimeItem", for: indexPath) as! CurrentSeasonAnimeItem
        
        cell.initialSetup(urlImage: data.images?.jpg?.imageUrl ?? "", title: data.title ?? "")
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 110, height: 205)
    }

}
