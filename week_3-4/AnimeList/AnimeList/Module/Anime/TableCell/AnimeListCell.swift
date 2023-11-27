import UIKit
import RxSwift
import RxCocoa

class AnimeListCell: UITableViewCell {
    
    @IBOutlet weak var increamentEpisodeButton: UIButton!
    @IBOutlet weak var animeEpisode: UILabel!
    @IBOutlet weak var progressIndicatorView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var statusWatchView: UIView!
    @IBOutlet weak var statusWatchLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var myScoreLabel: UILabel!
    @IBOutlet weak var myEpisodeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var airedLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        configureButtonGesture()
    }
    
    func initialSetup(
        data: UserAnimeEntity){
            titleLabel.text = data.anime.title
            airedLabel.text = data.anime.status
            releaseDateLabel.text = "\(data.anime.type ?? ""), \(data.anime.season ?? "") \(data.anime.year.map { "\($0)" } ?? "")"
            statusWatchLabel.text = statusWatchSetup(status: data.watchStatus)
            animeEpisode.text = data.anime.episodes.map { "\($0)" } ?? "??"
            myEpisodeLabel.text = String(data.userEpisode)
            myScoreLabel.text = String(data.userScore)
            let genres = data.anime.genres.compactMap {$0.name}
            genreLabel.text = genres.joined(separator: " • ")
            if let imageURL = URL(string: data.anime.images?.jpg?.imageUrl ?? "") {
                self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
            }
        }
    
    func configureUI(){
        editButton.addBorder(width: 1, color: UIColor.lightGray)
        increamentEpisodeButton.addBorder(width: 1, color: UIColor.lightGray)
        deleteButton.addBorder(width: 1, color: UIColor.lightGray)
        editButton.roundCornersAll(radius: 4)
        increamentEpisodeButton.roundCornersAll(radius: 4)
        deleteButton.roundCornersAll(radius: 4)
        urlImage.roundCornersAll(radius: 8)
        statusWatchView.roundCornersAll(radius: 8)
    }
    
    func configureButtonGesture(){
        deleteButton.rx.tap.subscribe(onNext: {_ in
            UserAnimeViewModel.shared.deleteUserAnime(id: ""){result in
                
            }
        })
    }
    
    func statusWatchSetup(status: Int) -> String {
        switch status {
        case 0:
            statusWatchView.backgroundColor = UIColor.systemGreen
            return "CW"
        case 1:
            statusWatchView.backgroundColor = UIColor.systemBlue
            return "CMP"
        case 2:
            statusWatchView.backgroundColor = UIColor.systemOrange
            return "OH"
        case 3:
            statusWatchView.backgroundColor = UIColor.systemRed
            return "DRP"
        case 4:
            statusWatchView.backgroundColor = UIColor.systemBrown
            return "PTW"
        default:
            return ""
        }
    }
}
