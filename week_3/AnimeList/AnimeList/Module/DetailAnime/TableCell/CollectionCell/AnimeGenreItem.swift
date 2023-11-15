import UIKit

class AnimeGenreItem: UICollectionViewCell {
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponentStyle()
    }
    
    func configureComponentStyle(){
        itemView.roundCornersAll(radius: 10)
        
        itemView.layer.borderWidth = 1.0
        itemView.layer.borderColor = UIColor.white.cgColor
    }
    
    func initialSetup(genre: String){
        genreLabel.text = genre
    }
    
}
