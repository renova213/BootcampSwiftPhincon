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
    
    func initialSetupAnime(data: AnimeEntity){
        self.title.text = data.title ?? ""
        
        self.episode.text = "\(data.type ?? "") (\(String(data.episodes ?? 0)) episode)"
        
        self.releaseDate.text = data.aired?.string ?? ""
        
        if let ratingData = data.score {
            rating.text = String(ratingData)
        }else{
            rating.text = "-"
        }
        
        if let imageURL = URL(string: data.images?.jpg?.imageUrl ?? "") {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
    
    func initialSetupManga(data: MangaEntity){
        self.title.text = data.title ?? ""
        
        self.episode.text = "\(data.type ?? "") (\(String(data.chapters ?? 0)) episode)"
        
        self.releaseDate.text = data.published.string ?? ""
        
        if let ratingData = data.score {
            rating.text = String(ratingData)
        }else{
            rating.text = "-"
        }
        
        if let imageURL = URL(string: data.images?.jpg?.imageUrl ?? "") {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
}
