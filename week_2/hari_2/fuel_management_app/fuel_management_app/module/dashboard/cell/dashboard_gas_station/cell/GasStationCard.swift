//
//  GasStationCard.swift
//  latihan_hari_5
//
//  Created by Phincon on 27/10/23.
//

import UIKit

protocol GasStationCardDelegate: AnyObject {
    func didTapGasStationCard()
}

class GasStationCard: UICollectionViewCell {

    @IBOutlet weak var gasStationView: UIView!
    @IBOutlet weak var spbuImage: UIImageView!
    @IBOutlet weak var spbuNameLabel: UILabel!
    @IBOutlet weak var totalReviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    weak var delegate: GasStationCardDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        spbuImage.layer.cornerRadius = 12
        spbuImage.contentMode = .scaleAspectFit
        
        // Menambahkan UITapGestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gasStationView.addGestureRecognizer(tapGesture)

        // Mengaktifkan user interaction agar view dapat menerima gesture
        gasStationView.isUserInteractionEnabled = true
    }
    
    @objc func handleTap() {
         delegate?.didTapGasStationCard()
     }
}
