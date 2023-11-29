import UIKit
import Kingfisher

class TopAnimeTableCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var scoredByLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        cardView.roundCornersAll(radius: 10)
        rankView.roundCornersAll(radius: 3)
        urlImage.roundCornersAll(radius: 10)
    }
    
    func initialSetup(){
        scoredByLabel.text = "330.552"
        scoreLabel.text = "9.12"
        episodeLabel.text = "TV (28 Episode)"
        titleLabel.text = "Sousou no Frieren"
        if let url = URL(string: "https://m.media-amazon.com/images/M/MV5BMjVjZGU5ZTktYTZiNC00N2Q1LThiZjMtMDVmZDljN2I3ZWIwXkEyXkFqcGdeQXVyMTUzMTg2ODkz._V1_FMjpg_UX1000_.jpg"){
            urlImage.kf.setImage(with: url, placeholder: UIImage(systemName: "ImagePlaceholder"))
        }
        rankLabel.text = "#1"
    }
}
