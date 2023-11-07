//
//  GasStationCard.swift
//  fuel_management_app
//
//  Created by Phincon on 02/11/23.
//

import UIKit
import Kingfisher


class GasStationCard: UICollectionViewCell {

    @IBOutlet weak var spbuImage: UIImageView!
    @IBOutlet weak var spbuLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var totalReview: UILabel!
    @IBOutlet weak var lokasi: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spbuImage.layer.cornerRadius = 12
        spbuImage.contentMode = .scaleAspectFit
        spbuImage.isUserInteractionEnabled = true
        spbuImage.contentMode = .scaleAspectFit
        
    }
}
