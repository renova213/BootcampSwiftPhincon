import UIKit

class ProfileSettingCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialSetup(image: UIImage, title: String){
        titleLabel.text = title
        iconImage.image = image
    }
}
