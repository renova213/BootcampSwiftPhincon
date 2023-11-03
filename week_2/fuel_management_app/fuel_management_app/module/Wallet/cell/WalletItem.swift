//
//  WalletItem.swift
//  fuel_management_app
//
//  Created by Phincon on 02/11/23.
//

import UIKit

class WalletItem: UITableViewCell {

    
    @IBOutlet weak var walletContainer: UIView!
    
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
