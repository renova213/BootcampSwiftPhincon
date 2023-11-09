//
//  DashboardCategoryItem.swift
//  AnimeList
//
//  Created by Phincon on 09/11/23.
//

import UIKit

class DashboardCategoryItem: UICollectionViewCell {

    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryItemView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponentStyle()
    }
    
    func configureComponentStyle(){
        categoryItemView.roundCornersAll(radius: 8)
//        categoryItemView.backgroundColor = UIColor(named: "Main Color")
        
        categoryName.font = .robotoMedium(size: 16)
    }
}
