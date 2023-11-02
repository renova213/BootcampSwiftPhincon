//
//  FuelTypeCard.swift
//  latihan_hari_5
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class FuelTypeCard: UICollectionViewCell {

    @IBOutlet weak var fuelTypeChip: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fuelTypeChipStyle()
    }
    
    func fuelTypeChipStyle(){
        fuelTypeChip.layer.cornerRadius = 20
    }

}
