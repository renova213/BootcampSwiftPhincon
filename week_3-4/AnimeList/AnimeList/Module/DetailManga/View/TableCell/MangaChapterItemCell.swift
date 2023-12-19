import UIKit

class MangaChapterItemCell: UITableViewCell {

    @IBOutlet weak var chapterContainer: UIView!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        chapterContainer.layer.borderColor = UIColor(named: "Main Color")?.cgColor
        chapterContainer.layer.borderWidth = 1
        chapterContainer.roundCornersAll(radius: 4)
    }
    
    func initialSetup(data: MangaChaptersEntity){
        episodeLabel.text = "Ch. \(data.attributes.chapter ?? "-") - \(data.attributes.title ?? "-")"
        subtitleLabel.text = "Volume \(data.attributes.volume ?? "-") | \(data.attributes.updatedAt?.convertToCustomDateFormat() ?? "-")"
    }
}
