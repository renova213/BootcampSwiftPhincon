import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

protocol AnimeListCellDelegate: AnyObject {
    func didTap(data: UserAnimeEntity)
    func increamentEpisode(data: UserAnimeEntity)
}

class AnimeListCell: UITableViewCell {
    
    @IBOutlet weak var containerProgressIndicator: UIView!
    @IBOutlet weak var increamentEpisodeButton: UIButton!
    @IBOutlet weak var animeEpisode: UILabel!
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
    @IBOutlet weak var progressIndicator: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        configureButtonGesture()
    }
    
    weak var delegate: AnimeListCellDelegate?
    private lazy var userAnimeVM = UserAnimeViewModel.shared
    var userAnime: UserAnimeEntity?
    private let disposeBag = DisposeBag()
    
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
            if let episode = data.anime.episodes {
                let progressValue = Float(data.userEpisode) / Float(episode)
                progressIndicator.progress = progressValue
            }else{
                progressIndicator.progress = 0
            }
            
            userAnime = data
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
        containerProgressIndicator.roundCornersAll(radius: 4)
    }
    
    func configureButtonGesture(){
        deleteButton.rx.tap.subscribe(onNext: {_ in
            self.deleteButton.isEnabled = false
            if let dataID = self.userAnime?.id {
                self.deleteButton.bounceAnimation(duration: 0.5)
                self.userAnimeVM.deleteUserAnime(id: dataID){result in
                    switch result {
                    case .success:
                        if let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults(){
                            self.userAnimeVM.getUserAnime(userId: userId){finish in}
                            self.deleteButton.isEnabled = true
                            self.contentView.makeToast("Delete success")
                        }
                        break
                    case .failure(let error):
                        self.deleteButton.isEnabled = true
                        if let error = error as? CustomError{
                            self.contentView.makeToast(error.message)
                        }
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        editButton.rx.tap.subscribe(onNext: {_ in
            if let data = self.userAnime{
                self.editButton.bounceAnimation(duration: 0.5)
                self.delegate?.didTap(data: data)
            }
        }).disposed(by: disposeBag)
        
        increamentEpisodeButton.rx.tap.subscribe(onNext: {_ in
            if let data = self.userAnime{
                self.increamentEpisodeButton.bounceAnimation(duration: 0.5)
                self.delegate?.increamentEpisode(data: data)
            }
        }).disposed(by: disposeBag)
    }
    
    func statusWatchSetup(status: Int) -> String {
        switch status {
        case 0:
            statusWatchView.backgroundColor = UIColor.systemGreen
            progressIndicator.tintColor = UIColor.systemGreen
            return "CW"
        case 1:
            statusWatchView.backgroundColor = UIColor.systemBlue
            progressIndicator.tintColor = UIColor.systemBlue
            return "CMP"
        case 2:
            statusWatchView.backgroundColor = UIColor.systemOrange
            progressIndicator.tintColor = UIColor.systemOrange
            return "OH"
        case 3:
            statusWatchView.backgroundColor = UIColor.systemRed
            progressIndicator.tintColor = UIColor.systemRed
            return "DRP"
        case 4:
            statusWatchView.backgroundColor = UIColor.systemBrown
            progressIndicator.tintColor = UIColor.systemBrown
            return "PTW"
        default:
            return ""
            
        }
    }
}
