import UIKit
import Kingfisher

class ProfileRecentUpdateItemCell: UITableViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialSetup(){
        if let url = URL(string: "https://upload.wikimedia.org/wikipedia/en/e/ef/Air_Gear_1.png"){
            urlImage.kf.setImage(with: url, placeholder: UIImage(named: "ImagePlaceholder"))
        }
        episodeLabel.text = "watching 2 of 24"
        statusLabel.text = "Scored 8 · May 16, 2020 02:25AM"
        titleSetup()
    }
    
    func titleSetup(){
        let attributedString = NSMutableAttributedString()
        attributedString.appendText("Watching ", textColor: UIColor.darkGray, font: UIFont(name: "HelveticaNeue-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular))
        
        attributedString.appendText("Air Gear", textColor: UIColor(named: "Main Color") ?? UIColor.black, font: UIFont(name: "HelveticaNeue-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium))
        
        titleLabel.attributedText = attributedString
    }
}
