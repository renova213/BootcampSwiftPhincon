import UIKit
import Kingfisher

class SearchResult: UITableViewCell {

    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var episode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyleComponent()
    }
    
    func configureStyleComponent(){
        searchView.roundCornersAll(radius: 12)
        searchView.backgroundColor = UIColor(named: "Main Color")?.withAlphaComponent(0.8)
        
        urlImage.roundCornersAll(radius: 12)
    }
    
    func initialSetup(urlImage: String, title: String, episode: String, rating: String, releaseDate: String){
        self.title.text = title
        self.episode.text = episode
        self.rating.text = rating
        self.releaseDate.text = releaseDate
        if let imageURL = URL(string: urlImage) {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
}
