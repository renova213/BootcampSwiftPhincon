//
//  DashboardCategoryItem.swift
//  AnimeList
//
//  Created by Phincon on 10/11/23.
//

import UIKit

class DashboardCategoryItem: UICollectionViewCell {

    @IBOutlet weak var categoryItemView: UIView!
    @IBOutlet weak var categoryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponentStyle()
    }
    
    func configureComponentStyle(){
        categoryItemView.roundCornersAll(radius: 12)
    }
    
    func setUpButton(title: String, icon: UIImage){
        categoryButton.setTitle(title, for: .normal)
        categoryButton.setImage(icon, for: .normal)
    }
}
