//
//  DashboardUsedBBM.swift
//  latihan_hari_5
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class DashboardUsedBBM: UITableViewCell {
    
    @IBOutlet weak var typeBBMCollection: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(){
        typeBBMCollection.delegate = self
        typeBBMCollection.dataSource = self
        typeBBMCollection.registerCellWithNib(FuelTypeCard.self)
    }
}

extension DashboardUsedBBM: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.showsHorizontalScrollIndicator = false
        
        let fuelTypeCardCell = typeBBMCollection.dequeueReusableCell(withReuseIdentifier: "FuelTypeCard", for: indexPath)as! FuelTypeCard
        
        return fuelTypeCardCell
    }
}
