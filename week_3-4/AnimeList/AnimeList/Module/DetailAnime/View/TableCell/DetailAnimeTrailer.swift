import UIKit
import YouTubePlayer

class DetailAnimeTrailer: UITableViewCell {
    
    @IBOutlet weak var youtubePlayer: YouTubePlayerView!
    var youtubeId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        loadVideoPlayer()
    }
    
    func loadVideoPlayer(){
        youtubePlayer.loadVideoID(youtubeId ?? "")
    }
    
    func initialYoutubeId(youtubeId: String){
        self.youtubeId = youtubeId
    }
}
