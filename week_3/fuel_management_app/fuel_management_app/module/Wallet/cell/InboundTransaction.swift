//
//  InboundTransaction.swift
//  fuel_management_app
//
//  Created by Phincon on 03/11/23.
//

import UIKit

class InboundTransaction: UITableViewCell {

    
    @IBOutlet weak var walletContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpComponentStyle()
    }
    
    func setUpComponentStyle(){
        walletContainer.roundCornersAll(radius: 10)
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }

}
