//
//  HistoryCard.swift
//  fuel_management_app
//
//  Created by Phincon on 03/11/23.
//

import UIKit

class HistoryCard: UITableViewCell {

    @IBOutlet weak var spbuImage: UIImageView!
    
    @IBOutlet weak var historyCardView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpStyleComponent()
    }

    func setUpStyleComponent(){
        spbuImage.roundCornersAll(radius: 12)
        
        historyCardView.layer.cornerRadius = 8.0
        historyCardView.layer.shadowColor = UIColor.black.cgColor
        historyCardView.layer.shadowOpacity = 0.2
        historyCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        historyCardView.layer.shadowRadius = 4
    }
}
