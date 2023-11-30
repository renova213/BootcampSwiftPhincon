import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
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
        self.titleLabel.text = data.title ?? ""
        
        self.episodeLabel.text = "\(data.type ?? "") (\(String(data.episodes ?? 0)) episode)"
        
        self.releaseLabel.text = data.aired?.string ?? ""
        
        if let score = data.score {
            scoreLabel.text = String(score)
        }else{
            scoreLabel.text = "-"
        }
        
        if let imageURL = URL(string: data.images?.jpg?.imageUrl ?? "") {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
    
    func initialSetupManga(data: MangaEntity){
        self.titleLabel.text = data.title ?? ""
        
        self.episodeLabel.text = "\(data.type ?? "") (\(String(data.chapters ?? 0)) episode)"
        
        self.releaseLabel.text = data.published.string ?? ""
        
        if let ratingData = data.score {
            scoreLabel.text = String(ratingData)
        }else{
            scoreLabel.text = "-"
        }
        
        if let imageURL = URL(string: data.images?.jpg?.imageUrl ?? "") {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
}
