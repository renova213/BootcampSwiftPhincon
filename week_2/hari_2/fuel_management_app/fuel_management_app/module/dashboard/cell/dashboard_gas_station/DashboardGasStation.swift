//
//  DashboardGasStation.swift
//  latihan_hari_5
//
//  Created by Phincon on 27/10/23.
//

import UIKit

class DashboardGasStation: UITableViewCell {
    var navigationController: UINavigationController?
    
    @IBOutlet weak var gasStationCollection: UICollectionView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.showsHorizontalScrollIndicator = false
        let data: GasStationEntity = GasStationEntity.gasStations[indexPath.row]
        
        let gasStationCardCell = gasStationCollection.dequeueReusableCell(withReuseIdentifier: "GasStationCard", for: indexPath) as! GasStationCard
        
        if let delegate = self as? GasStationCardDelegate {
            gasStationCardCell.delegate = delegate
            
            func handleTap() {
                print("Gas station card tapped")
            }
        }
        
        
        gasStationCardCell.spbuNameLabel.text = data.name
        gasStationCardCell.spbuImage.image = UIImage(named: data.imageAsset)
        gasStationCardCell.ratingLabel.text = String(data.rating)
        gasStationCardCell.totalReviewLabel.text = "(\(data.totalReview)"
        return gasStationCardCell
    }
    
   

}


