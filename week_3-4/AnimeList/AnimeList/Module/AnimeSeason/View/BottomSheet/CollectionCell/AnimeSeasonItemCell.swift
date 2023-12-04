import UIKit
import RxSwift
import RxCocoa

protocol AnimeSeasonItemCellDelegate: AnyObject {
    func didTapSeason(index: Int, season: String)
}

class AnimeSeasonItemCell: UICollectionViewCell {
    
    @IBOutlet weak var seasonButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        buttonGesture()
    }
    private let disposeBag = DisposeBag()
    weak var delegate: AnimeSeasonItemCellDelegate?
    
    func buttonGesture(){
        seasonButton.rx.tap.subscribe(onNext: {_ in
            if let index = self.index, let season = self.season {
                self.delegate?.didTapSeason(index: index, season: season)
            }
        }).disposed(by: disposeBag)
    }
    var index: Int?
    var season: String?
    
    func initialSetup(season: String, selectedSeasonIndex: Int, index: Int){
        self.index = index
        if(selectedSeasonIndex == index){
            self.seasonButton.tintColor = UIColor.systemOrange
            self.seasonButton.backgroundColor = UIColor.systemOrange
        }else{
            self.seasonButton.tintColor = UIColor.lightGray
            self.seasonButton.backgroundColor = UIColor.systemOrange
        }
        
        switch season {
        case "winter":
            seasonButton.setImage(UIImage(systemName: "snowflake"), for: .normal)
            self.season = "winter"
        case "spring":
            seasonButton.setImage(UIImage(systemName: "tree.fill"), for: .normal)
            self.season = "spring"
        case "summer":
            seasonButton.setImage(UIImage(systemName: "sun.max.fill"), for: .normal)
            self.season = "summer"
        case "fall":
            seasonButton.setImage(UIImage(systemName: "leaf.fill"), for: .normal)
            self.season = "fall"
        default:
            break
        }
    }
    
    func configureUI(){
        seasonButton.roundCornersAll(radius: 25)
    }
}
