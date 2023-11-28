import UIKit
import Kingfisher

class CurrentSeasonAnimeItem: UICollectionViewCell {

    @IBOutlet weak var animeCardItem: AnimeCardItem!

    override func awakeFromNib() {
        super.awakeFromNib()
        animeCardItem.configureView()
    }
    
    func initialSetup(data: AnimeEntity){
        animeCardItem.initialSetup(urlImage: data.images?.jpg?.imageUrl ?? "", type: data.type ?? "", rank: data.rank, title: data.title ?? "", score: data.score)
    }
}
