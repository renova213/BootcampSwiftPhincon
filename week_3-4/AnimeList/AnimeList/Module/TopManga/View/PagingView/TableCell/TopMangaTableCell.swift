import UIKit

class TopMangaTableCell: UITableViewCell {
    
    @IBOutlet weak var rankContainer: UIView!
    @IBOutlet weak var topMangaContainer: UIView!
    @IBOutlet weak var scoredByLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        topMangaContainer.roundCornersAll(radius: 10)
        rankContainer.roundCornersAll(radius: 3)
        urlImage.roundCornersAll(radius: 10)
    }
    
    func initialSetup(data: MangaEntity, index: Int){
        scoredByLabel.text = (data.scoredBy ?? 0).formatAsDecimalString()
        
        if let score = data.score {
            scoreLabel.text = String(score)
        }
        episodeLabel.text = "\(data.type ?? "-") (\(data.chapters ?? 0) Chapters)"
        title.text = data.title ?? "-"
        if let url = URL(string:data.images?.jpg?.imageUrl ?? ""){
            urlImage.kf.setImage(with: url, placeholder: UIImage(named: "ImagePlaceholder"))
        }
        rankLabel.text = "#\(index + 1)"
    }
}
