import UIKit
import Kingfisher

class ProfileInfoCell: UITableViewCell {
    
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialSetup(){
        nameLabel.text = "Rizco Renova"
        joinedLabel.text = "Joined january 10, 2020"
        birthdayLabel.text = "30 Oktober 1999"
    }
}
