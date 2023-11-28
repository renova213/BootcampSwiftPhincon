import UIKit

class UnselectedSearchCategoryItem: UICollectionViewCell {

    @IBOutlet weak var searchCategoryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyleComponent()
    }
    
    func configureStyleComponent(){
        searchCategoryButton.roundCornersAll(radius: 8)
        searchCategoryButton.layer.borderWidth = 1.0
        searchCategoryButton.layer.borderColor = UIColor(named: "Main Color")?.cgColor
        searchCategoryButton.isUserInteractionEnabled = false
    }
}
