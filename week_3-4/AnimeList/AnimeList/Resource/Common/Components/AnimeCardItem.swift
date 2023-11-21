import Foundation
import UIKit
import Kingfisher

class AnimeCardItem: UIView {
    
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var scoreStackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let view = self.loadNib()
        view.frame = self.bounds
        view.backgroundColor = .white
        self.addSubview(view)
    }
    
    func configureView(){
        cardView.roundCornersAll(radius: 10)
        rankView.backgroundColor = UIColor.clear
    }
    
    func initialSetup(urlImage: String, type: String, rank: Int?, title: String, score: Double?){
        self.typeLabel.text = type
        
        if let rankData = rank{
            self.rankLabel.text = "#\(String(rankData))"
        }else{
            self.rankLabel.text = "-"
        }
        
        if let scoreData = score{
            self.scoreLabel.text = String(scoreData)
        }else{
            self.scoreLabel.text = "-"
        }
        
        self.titleLabel.text = title
        
        if let imageURL = URL(string: urlImage) {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
}
