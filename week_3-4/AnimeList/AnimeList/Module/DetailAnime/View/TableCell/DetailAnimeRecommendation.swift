import UIKit

protocol DetailAnimeRecommendationDelegate: AnyObject{
    func didTapNavigation(malId: Int)
}

class DetailAnimeRecommendation: UITableViewCell {

    @IBOutlet weak var animeRecommendationCollection: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    var animeRecommendations:[AnimeRecommendationEntity] = []{
        didSet{
            animeRecommendationCollection.reloadData()
        }
    }
    
    weak var delegate: DetailAnimeRecommendationDelegate?
}

extension DetailAnimeRecommendation: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func configureCollectionView(){
        animeRecommendationCollection.delegate = self
        animeRecommendationCollection.dataSource = self
        animeRecommendationCollection.registerCellWithNib(AnimeRecommendationItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animeRecommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = animeRecommendations[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimeRecommendationItem", for: indexPath) as! AnimeRecommendationItem
        cell.initialSetup(data: data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 185)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = animeRecommendations[indexPath.row]
        if let id = data.entry?.malID{
            delegate?.didTapNavigation(malId: id)
        }
    }
}

extension DetailAnimeRecommendation {
    func initialSetup(data: [AnimeRecommendationEntity]){
        animeRecommendations = data
    }
}
