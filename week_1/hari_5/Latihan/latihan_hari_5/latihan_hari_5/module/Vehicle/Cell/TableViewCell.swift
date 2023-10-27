//
//  TableViewCell.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var vehicleName: UILabel!
    @IBOutlet weak var platNumber: UILabel!
    @IBOutlet weak var vehicleCard: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vehicleCardStyle(view: vehicleCard)
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func vehicleCardStyle(view: UIView) {
        view.layer.cornerRadius = 8.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
       }
    
}
