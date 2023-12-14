import UIKit
import Kingfisher

class ProfileRecentUpdateItemCell: UITableViewCell {
    
    @IBOutlet weak var progressIndicator: UIProgressView!
    @IBOutlet weak var statusWatchView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func initialSetup(data: UserRecentUpdateEntity){
        var watchStatus = ""

        if let url = URL(string: data.image){
            urlImage.kf.setImage(with: url, placeholder: UIImage(named: "ImagePlaceholder"))
        }
        
        let progressValue = Float(data.userEpisode) / Float(data.episode)
        progressIndicator.progress = progressValue
        
        switch data.watchStatus{
        case 0:
            progressIndicator.tintColor = UIColor.systemGreen
            watchStatus = "watching"
        case 1:
            progressIndicator.tintColor = UIColor.systemBlue
            watchStatus = "completed"
        case 2:
            progressIndicator.tintColor = UIColor.systemOrange
            watchStatus = "on hold"
        case 3:
            watchStatus = "drop"
            progressIndicator.tintColor = UIColor.systemRed
        case 4:
            progressIndicator.tintColor = UIColor.systemBrown
            watchStatus = "plan to watch"
        default:
            break
        }
        
        let attributedString = NSMutableAttributedString()
        
        attributedString.appendText(data.title, textColor: UIColor(named: "Main Color") ?? UIColor.black, font: UIFont(name: "HelveticaNeue-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium))
        
        titleLabel.attributedText = attributedString
        episodeLabel.text = "\(watchStatus) \(data.userEpisode) of \(data.episode) · Scored \(data.userScore)"
        statusLabel.text = data.updatedAt
    }
}
