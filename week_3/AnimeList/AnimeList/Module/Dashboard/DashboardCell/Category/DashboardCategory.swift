//
//  DashboardCategory.swift
//  AnimeList
//
//  Created by Phincon on 09/11/23.
//

import UIKit

class DashboardCategory: UITableViewCell {
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
    }
}

extension DashboardCategory: UICollectionViewDelegate, UICollectionViewDataSource {
    func configureTableView(){
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        categoryCollection.registerCellWithNib(DashboardCategoryItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCategoryItem", for: indexPath) as! DashboardCategoryItem
        
        return cell
    }
}
