//
//  GasStationCard.swift
//  latihan_hari_5
//
//  Created by Phincon on 27/10/23.
//

import UIKit


class GasStationCard: UICollectionViewCell {

    @IBOutlet weak var gasStationView: UIView!
    @IBOutlet weak var spbuImage: UIImageView!
    @IBOutlet weak var spbuNameLabel: UILabel!
    @IBOutlet weak var totalReviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        spbuImage.layer.cornerRadius = 12
        spbuImage.contentMode = .scaleAspectFit
        
        // Menambahkan UITapGestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        gasStationView.addGestureRecognizer(tapGesture)

        // Mengaktifkan user interaction agar view dapat menerima gesture
        gasStationView.isUserInteractionEnabled = true
    }
    
    @objc func viewTapped() {
            // Aksi yang ingin dijalankan ketika gasStationView ditekan
            print("Gas station view tapped!")
            // Tambahkan kode aksi yang diinginkan di sini
        }
}
