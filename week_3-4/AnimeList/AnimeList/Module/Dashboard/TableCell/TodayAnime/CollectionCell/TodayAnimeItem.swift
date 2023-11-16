import UIKit
import Kingfisher

class TodayAnimeItem: UICollectionViewCell {

    @IBOutlet weak var animeTitle: UILabel!
    @IBOutlet weak var dateRelease: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponentStyle()
    }
    
    func setUpComponent (title: String, date: String, urlImage: String, rating: Double?){
        animeTitle.text = title
        dateRelease.text = date
        if let ratingData = rating {
            self.rating.text = String(ratingData)
        }else{
            self.rating.text = "-"
        }
        
        if let imageURL = URL(string: urlImage) {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
    
    func configureComponentStyle(){
        urlImage.roundCornersAll(radius: 8)
    }
}
