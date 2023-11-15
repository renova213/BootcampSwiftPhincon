//
//  AnimeDetailInfo.swift
//  AnimeList
//
//  Created by Phincon on 15/11/23.
//

import UIKit

class AnimeDetailInfo: UITableViewCell {
    
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyleComponent()
    }
    
    func configureStyleComponent(){
        urlImage.roundCornersAll(radius: 10)
    }
    
    func initialSetup(data: AnimeEntity){
        
        if let imageURL = URL(string: data.images?.jpg?.imageUrl ?? "") {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
        
        if let titleAnime = data.title {
            title.text = titleAnime
        }else{
            title.text = "-"
        }
        
        if let type = data.type {
            typeLabel.text = type
        }else{
            typeLabel.text = "-"
        }
        
        if let status = data.status {
            statusLabel.text = status
        }else{
            statusLabel.text = "-"
        }
        
        if let episode = data.episodes {
            episodeLabel.text = "\(String(episode)) Episode"
        }else{
            episodeLabel.text = "-"
        }
        
        if let rating = data.score {
            ratingLabel.text = String(rating)
        }else{
            ratingLabel.text = "-"
        }
    }
}
