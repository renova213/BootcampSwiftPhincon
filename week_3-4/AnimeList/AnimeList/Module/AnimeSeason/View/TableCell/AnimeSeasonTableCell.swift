import UIKit

class AnimeSeasonTableCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI(){
        cardView.roundCornersAll(radius: 10)
        urlImage.roundCornersAll(radius: 10)
    }
    
    func initialSetup(data: AnimeEntity){
        if let score = data.score {
            scoreLabel.text = String(score)
        }
        episodeLabel.text = "\(data.type ?? "-") (\(data.episodes ?? 0) Episode)"
        titleLabel.text = data.title ?? "-"
        if let url = URL(string:data.images?.jpg?.imageUrl ?? ""){
            urlImage.kf.setImage(with: url, placeholder: UIImage(named: "ImagePlaceholder"))
        }
        timeLabel.text = "\(data.broadcast?.day ?? "") \(data.broadcast?.time ?? "")"
    }
}
