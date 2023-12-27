import UIKit

class MangaRatingScoreItem: UICollectionViewCell {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    func configureUI(){
        ratingView.layer.backgroundColor = UIColor.darkGray.cgColor
        ratingView.roundCornersAll(radius: 8)
    }
    
    func configureBorder(state: Bool){
        if(state){
            ratingView.layer.backgroundColor = UIColor.orange.cgColor
        }else{
            ratingView.layer.backgroundColor = UIColor.darkGray.cgColor
        }
    }
}
