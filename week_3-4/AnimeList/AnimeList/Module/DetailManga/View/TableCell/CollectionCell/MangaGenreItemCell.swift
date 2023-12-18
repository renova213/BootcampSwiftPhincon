import UIKit

class MangaGenreItemCell: UICollectionViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func initialSetup(genre: DetailMangaGenre){
        genreLabel.text = genre.name
    }
    
    func configureUI(){
        genreContainer.layer.borderWidth = 1.0
        genreContainer.layer.borderColor = UIColor(named: "Main Color")?.cgColor
        genreContainer.roundCornersAll(radius: 8)
    }
}
