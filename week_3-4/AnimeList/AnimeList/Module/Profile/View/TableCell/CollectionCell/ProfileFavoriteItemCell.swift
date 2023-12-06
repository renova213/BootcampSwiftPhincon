import UIKit
import Kingfisher

class ProfileFavoriteItemCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var itemView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureUI(){
        itemView.roundCornersAll(radius: 8)
    }
    
    func initialSetup(){
        titleLabel.text = "K-On!"
        if let url = URL(string: "https://m.media-amazon.com/images/M/MV5BODNiM2Q4ZDYtNmU1Ny00OTRhLThjY2QtNzE4MzZlMzFjMDY3XkEyXkFqcGdeQXVyNjQwNzI5MDA@._V1_FMjpg_UX1000_.jpg") {
            urlImage.kf.setImage(with: url, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
}
