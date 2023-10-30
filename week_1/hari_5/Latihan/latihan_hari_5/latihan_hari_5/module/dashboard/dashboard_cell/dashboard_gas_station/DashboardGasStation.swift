//
//  DashboardGasStation.swift
//  latihan_hari_5
//
//  Created by Phincon on 27/10/23.
//

import UIKit

class DashboardGasStation: UITableViewCell {
    
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
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.showsHorizontalScrollIndicator = false
        
        let gasStationCardCell = gasStationCollection.dequeueReusableCell(withReuseIdentifier: "GasStationCard", for: indexPath) as!GasStationCard
        return gasStationCardCell
    }
}

