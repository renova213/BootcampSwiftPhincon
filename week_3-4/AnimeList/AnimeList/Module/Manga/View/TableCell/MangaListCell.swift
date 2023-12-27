import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import Hero

class MangaListCell: UITableViewCell {
    
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
    
    var userManga: UserMangaEntity?
    private let disposeBag = DisposeBag()
    
    func initialSetup(
        data: UserMangaEntity){
            titleLabel.text = data.manga.title
            airedLabel.text = data.manga.status
            releaseDateLabel.text = "\(data.manga.type ?? ""), \(data.manga.published.prop.from?.year ?? 0)"
            statusWatchLabel.text = statusWatchSetup(status: data.watchStatus)
            animeEpisode.text = "\(data.manga.chapters ?? 0) chapters"
            myEpisodeLabel.text = String(data.userEpisode)
            myScoreLabel.text = String(data.userScore)
            let genres = data.manga.genres.compactMap {$0.name}
            genreLabel.text = genres.joined(separator: " • ")
            if let imageURL = URL(string: data.manga.images?.jpg?.imageUrl ?? "") {
                self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
            }
            if let episode = data.manga.chapters {
                let progressValue = Float(data.userEpisode) / Float(episode)
                progressIndicator.progress = progressValue
            }else{
                progressIndicator.progress = 0
            }
            urlImage.heroID = String(data.manga.malId)
            userManga = data
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
        deleteButton.rx.tap.subscribe(onNext: {[weak self]_ in
            
            guard let self = self, let userManga = self.userManga else { return }
            
            MangaViewModel.shared.deleteUserMAngaRelay.accept(userManga.id)
        }).disposed(by: disposeBag)
        
        increamentEpisodeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self, let data = self.userManga else { return }
            
            self.increamentEpisodeButton.bounceAnimation(duration: 0.5)
            MangaViewModel.shared.increamentMangaChapterRelay.accept(UpdateUserMangaParam(id: data.id, userEpisode: data.userEpisode + 1, watchStatus: data.watchStatus, userScore: data.userScore))
            
        }).disposed(by: disposeBag)
        
        editButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            
            if let userManga = self.userManga{
                MangaViewModel.shared.showUpdateMangaListBottomSheetRelay.accept(userManga)
            }
        }).disposed(by: disposeBag)
    }
    
    func statusWatchSetup(status: Int) -> String {
        switch status {
        case 0:
            statusWatchView.backgroundColor = UIColor.systemGreen
            progressIndicator.tintColor = UIColor.systemGreen
            return "CR"
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
