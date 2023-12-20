import UIKit
import Kingfisher

class ReadMangaViewCell: UICollectionViewCell {

    @IBOutlet weak var urlImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialSetup(urlImage: String){
        if let imageURL = URL(string: urlImage) {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "error_image"))
        }
    }
}
