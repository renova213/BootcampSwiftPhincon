import UIKit

class AnimeRecommendationItem: UICollectionViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    func initialSetup(data: AnimeRecommendationEntity){
        if let vote = data.votes{
            self.voteLabel.text = String(vote)
        }else{
            self.voteLabel.text = "-"
        }
        
        self.titleLabel.text = data.entry?.title ?? "-"
        
        if let imageURL = URL(string: data.entry?.images?.jpg?.imageURL ?? "") {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
    
    func configureView(){
        cardView.roundCornersAll(radius: 10)
    }
}
