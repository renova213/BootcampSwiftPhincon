import UIKit

class FilterPopUpTableCell: UITableViewCell {
    
    @IBOutlet weak var radioImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialSetup(title: String,index: Int, currentIndex: Int){
        titleLabel.text = title
        switch index == currentIndex {
        case true:
            radioImage.image = UIImage(named: "radio_true")
        case false:
            radioImage.image = UIImage(named: "radio_false")
        }
    }
}
