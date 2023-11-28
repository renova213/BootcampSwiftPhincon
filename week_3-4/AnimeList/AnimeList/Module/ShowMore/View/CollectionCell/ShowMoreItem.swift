import UIKit
import SkeletonView

class ShowMoreItem: UICollectionViewCell {

    @IBOutlet weak var animeCardItem: AnimeCardItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animeCardItem.configureView()
    }
    
    func initialSetupAnime(data: AnimeEntity){
        animeCardItem.initialSetup(urlImage: data.images?.jpg?.imageUrl ?? "", type: data.type ?? "", rank: data.rank, title: data.title ?? "", score: data.score)
    }
}
