import UIKit

protocol DetailAnimeCharacterDelegate: AnyObject{
    func didTapWebKitCharacter(url: URL)
}

class DetailAnimeCharacter: UITableViewCell {
    
    @IBOutlet weak var animeCharacterCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollection()
    }
    
    var animeCharacter: [AnimeCharacterEntity] = []{
        didSet{
            animeCharacterCollection.reloadData()
        }
    }
    
    weak var delegate: DetailAnimeCharacterDelegate?
}

extension DetailAnimeCharacter {
    func initialSetup(data: [AnimeCharacterEntity]){
        animeCharacter = data
    }
}

extension DetailAnimeCharacter: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func configureCollection(){
        animeCharacterCollection.delegate = self
        animeCharacterCollection.dataSource = self
        animeCharacterCollection.registerCellWithNib(AnimeCharacterItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animeCharacter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = animeCharacter[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimeCharacterItem", for: indexPath) as! AnimeCharacterItem
        cell.delegate = self
        cell.initialSetup(data: data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 360)
    }
}

extension DetailAnimeCharacter: AnimeCharacterItemDelegate{
    
    func didSelectCell(url: String) {
        if let urlData = URL(string: url) {
            delegate?.didTapWebKitCharacter(url: urlData)
        }
    }
}
