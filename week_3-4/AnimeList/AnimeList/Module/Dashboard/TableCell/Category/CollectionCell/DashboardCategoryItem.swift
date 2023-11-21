import UIKit

class DashboardCategoryItem: UICollectionViewCell {

    @IBOutlet weak var categoryItemView: UIView!
    @IBOutlet weak var categoryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponentStyle()
    }
    
    func configureComponentStyle(){
        categoryItemView.roundCornersAll(radius: 12)
        categoryButton.isEnabled = false
        categoryButton.backgroundColor = UIColor(named: "Main Color")
        categoryButton.setTitleColor(UIColor.white, for: .disabled)
    }
    
    func setUpButton(title: String, icon: UIImage){
        categoryButton.setTitle(title, for: .normal)
        categoryButton.setImage(icon, for: .normal)
    }
}
