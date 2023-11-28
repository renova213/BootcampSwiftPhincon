import UIKit

class DetailAnimeTheme: UITableViewCell {
    
    @IBOutlet weak var endingLabel: UILabel!
    @IBOutlet weak var openingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialSetup(data: AnimeDetailEntity){
        if let themeData = data.theme{
            let openingSong = themeData.openings?.compactMap{$0.replacingOccurrences(of: "\\", with: "") + "\n\n"}
            openingLabel.text = openingSong?.joined()
            let endingSong = themeData.endings?.compactMap{$0.replacingOccurrences(of: "\\", with: "") + "\n\n"}
            endingLabel.text = endingSong?.joined()
        }
    }
}
