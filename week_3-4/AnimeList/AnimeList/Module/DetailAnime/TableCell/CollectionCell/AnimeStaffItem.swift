import UIKit

class AnimeStaffItem: UICollectionViewCell {

    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var staffImage: UIImageView!
    @IBOutlet weak var staffNameLabel: UILabel!
    @IBOutlet weak var staffPositionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    }

    func initialSetup(data: AnimeStaffEntity){
        if let urlImage = URL(string: data.person?.images?.jpg?.imageURL ?? ""){
            self.staffImage.kf.setImage(with: urlImage, placeholder: UIImage(named: "ImagePlaceholder"))
        }
        staffNameLabel.text = data.person?.name ?? ""
        if let positions = data.positions{
            let positionsJoin = positions.compactMap {$0}.joined(separator: ", ")
            staffPositionLabel.text = positionsJoin
        }
    }
}
