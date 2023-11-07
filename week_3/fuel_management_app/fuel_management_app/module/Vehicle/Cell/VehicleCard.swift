//
//  TableViewCell.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit


class VehicleCard: UITableViewCell {
    
    @IBOutlet weak var vehicleName: UILabel!
    @IBOutlet weak var platNumber: UILabel!
    @IBOutlet weak var vehicleCard: UIView!
    @IBOutlet weak var vehicleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vehicleCardStyle(view: vehicleCard)
    }
    
    func vehicleCardStyle(view: UIView) {
        view.layer.cornerRadius = 8.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
       }
    
}
