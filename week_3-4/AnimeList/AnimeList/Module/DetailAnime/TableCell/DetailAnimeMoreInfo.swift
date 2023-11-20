import UIKit

class DetailAnimeMoreInfo: UITableViewCell {
    @IBOutlet weak var synonimLabel: UILabel!
    @IBOutlet weak var japaneseTitleLabel: UILabel!
    @IBOutlet weak var romajiLabel: UILabel!
    @IBOutlet weak var titleEnglish: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var seasons: UILabel!
    @IBOutlet weak var aired: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var studio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialSetup(data: AnimeDetailData){
        
        synonimLabel.text = data.titleSynonyms?.joined(separator: ", ")
        japaneseTitleLabel.text = data.titleJapanese ?? "-"
        romajiLabel.text = data.title ?? "-"
        titleEnglish.text = data.titleEnglish ?? "-"
        startDate.text = data.aired?.from
        if let startDateString = DateFormatter.customFormattedString(from: data.aired?.from ?? "", inputFormat: "yyyy-MM-dd'T'HH:mm:ssZ", outputFormat: "d MMMM yyyy") {
            startDate.text = startDateString
        }
        if let endDateString = DateFormatter.customFormattedString(from: data.aired?.to ?? "", inputFormat: "yyyy-MM-dd'T'HH:mm:ssZ", outputFormat: "d MMMM yyyy") {
            endDate.text = endDateString
        }
        seasons.text = data.season ?? "-"
        aired.text = data.aired?.string ?? "-"
        duration.text = data.duration ?? "-"
        source.text = data.source ?? "-"
        if let studioData = data.studios {
            let studioNames = studioData.compactMap { $0.name }

            studio.text = studioNames.joined(separator: ", ")
        }
    }
}
