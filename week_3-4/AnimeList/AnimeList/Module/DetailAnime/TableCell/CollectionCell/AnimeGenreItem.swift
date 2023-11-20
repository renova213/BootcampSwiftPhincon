import UIKit

class AnimeGenreItem: UICollectionViewCell {
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var genreView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponentView()
    }
    
    func initialSetup(genre: AnimeDetailGenre){
        genreLabel.text = genre.name
    }
    
    func configureComponentView(){
        genreView.layer.borderWidth = 1.0
        genreView.layer.borderColor = UIColor(named: "Main Color")?.cgColor
        genreView.roundCornersAll(radius: 8)
    }
}
