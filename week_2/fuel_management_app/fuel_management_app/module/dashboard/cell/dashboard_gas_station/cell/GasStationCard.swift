//
//  GasStationCard.swift
//  fuel_management_app
//
//  Created by Phincon on 02/11/23.
//

import UIKit

protocol GasStationCardDelegate: AnyObject {
    func didTapGasStationCard()
}

class GasStationCard: UICollectionViewCell {

    @IBOutlet weak var spbuImage: UIImageView!
    @IBOutlet weak var spbuLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var totalReview: UILabel!
    @IBOutlet weak var lokasi: UILabel!
    
    weak var delegate: GasStationCardDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        spbuImage.layer.cornerRadius = 12
        spbuImage.contentMode = .scaleAspectFit
        
        // Menambahkan UITapGestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        spbuImage.addGestureRecognizer(tapGesture)

        // Mengaktifkan user interaction agar view dapat menerima gesture
        spbuImage.isUserInteractionEnabled = true
    }
    
    @objc func handleTap() {
         delegate?.didTapGasStationCard()
     }
}
