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
    
    func initialSetup(title: String, urlImage: String){
        titleLabel.text = title
        if let url = URL(string: urlImage) {
            self.urlImage.kf.setImage(with: url, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
}
