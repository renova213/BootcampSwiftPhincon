//
//  TableViewCell.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var vehicleName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
