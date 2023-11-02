//
//  WalletItem.swift
//  fuel_management_app
//
//  Created by Phincon on 02/11/23.
//

import UIKit

class WalletItem: UITableViewCell {

    @IBOutlet weak var walletItemContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpComponentStyle()
    }
    
    func setUpComponentStyle(){
        walletItemContainer.roundRadius(topLeft: 10, topRight: 10, bottomLeft: 10, bottomRight: 10)
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }

}
