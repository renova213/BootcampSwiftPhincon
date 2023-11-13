//
//  CurrentSeasonAnimeItem.swift
//  AnimeList
//
//  Created by Phincon on 13/11/23.
//

import UIKit
import Kingfisher

class CurrentSeasonAnimeItem: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyle()
    }
    
    func configureStyle(){
        urlImage.roundCornersAll(radius: 8)
    }
    
    func initialSetup(urlImage: String, title: String){
        self.title.text = title
        if let imageURL = URL(string: urlImage) {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
}
