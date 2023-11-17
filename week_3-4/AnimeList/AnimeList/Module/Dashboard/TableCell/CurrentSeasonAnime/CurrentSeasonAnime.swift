import UIKit

protocol CurrentAnimeDelegate: AnyObject {
    func didTapCurrentAnime(data: AnimeEntity)
    func didTapShowMoreCurrentAnime()
}

class CurrentSeasonAnime: UITableViewCell {

    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var animeCategoryCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
        configureComponentStyle()
    }
    
    var currentSeasonAnime: [AnimeEntity] = []{
        didSet{
            animeCategoryCollection.reloadData()
        }
    }
    weak var delegate: CurrentAnimeDelegate?
    
    @IBAction func tapMoreButton(_ sender: Any) {
        delegate?.didTapShowMoreCurrentAnime()
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
        
        cell.initialSetup(data: data)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 130, height: 205)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = currentSeasonAnime[indexPath.row]

        delegate?.didTapCurrentAnime(data: data)
    }
}

extension CurrentSeasonAnime {
    func configureComponentStyle(){
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
}
