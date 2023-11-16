//
//  DashboardGasStation.swift
//  latihan_hari_5
//
//  Created by Phincon on 27/10/23.
//

import UIKit
import Kingfisher

protocol DashboardGasStationDelegate{
    func passData(withID id: String)
}

class DashboardGasStation: UITableViewCell {
    
    @IBOutlet weak var gasStationCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    var delegate: DashboardGasStationDelegate?
    
    
    func setup() {
        gasStationCollection.delegate = self
        gasStationCollection.dataSource = self
        gasStationCollection.registerCellWithNib(GasStationCard.self)
    }
}

extension DashboardGasStation: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GasStationEntity.gasStations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.passData(withID: String(indexPath.row))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.showsHorizontalScrollIndicator = false
        let data: GasStationEntity = GasStationEntity.gasStations[indexPath.row]
        
        let gasStationCardCell = gasStationCollection.dequeueReusableCell(withReuseIdentifier: "GasStationCard", for: indexPath) as! GasStationCard
        
        gasStationCardCell.spbuLabel.text = data.name
        if let imageUrl = URL(string: data.urlImage) {
            gasStationCardCell.spbuImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "eraser"))
        }
        gasStationCardCell.ratingLabel.text = String(data.rating)
        gasStationCardCell.totalReview.text = "(\(data.totalReview)"
        gasStationCardCell.lokasi.text = data.location
        return gasStationCardCell
    }
}


