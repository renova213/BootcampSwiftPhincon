//
//  AnimeSectionItem.swift
//  AnimeList
//
//  Created by Phincon on 10/11/23.
//

import UIKit
import Kingfisher

class AnimeSectionItem: UICollectionViewCell {

    @IBOutlet weak var animeTitle: UILabel!
    @IBOutlet weak var dateRelease: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponentStyle()
    }
    
    func setUpAnimeSection (title: String, date: String, urlImage: String, rating: Double){
        animeTitle.text = title
        dateRelease.text = date
        self.rating.text = String(rating)
        
        if let imageURL = URL(string: urlImage) {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
    
    func configureComponentStyle(){
        urlImage.roundCornersAll(radius: 8)
    }
}
