import UIKit

class SelectedSearchCategoryItem: UICollectionViewCell {
    
    @IBOutlet weak var searchCategoryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyleComponent()
    }
    
    func configureStyleComponent(){
        searchCategoryButton.roundCornersAll(radius: 8)
        searchCategoryButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        searchCategoryButton.isUserInteractionEnabled = false
    }
}
