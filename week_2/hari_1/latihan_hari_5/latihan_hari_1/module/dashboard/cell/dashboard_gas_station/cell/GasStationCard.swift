//
//  GasStationCard.swift
//  latihan_hari_5
//
//  Created by Phincon on 27/10/23.
//

import UIKit


class GasStationCard: UICollectionViewCell {

    @IBOutlet weak var spbuImage: UIImageView!
    @IBOutlet weak var spbuNameLabel: UILabel!
    @IBOutlet weak var totalReviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        spbuImage.layer.cornerRadius = 12
        spbuImage.contentMode = .scaleAspectFit
    }
}
