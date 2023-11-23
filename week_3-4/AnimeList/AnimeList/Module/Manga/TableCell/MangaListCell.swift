//
//  MangaListCell.swift
//  AnimeList
//
//  Created by Phincon on 23/11/23.
//

import UIKit

class MangaListCell: UITableViewCell {

    @IBOutlet weak var statusWatchView: UIView!
    @IBOutlet weak var statusWatchLabel: UILabel!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var animeScoreLabel: UILabel!
    @IBOutlet weak var totalReviewersLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var myScoreLabel: UILabel!
    @IBOutlet weak var myEpisodeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI(){
        urlImage.roundCornersAll(radius: 8)
        statusWatchView.roundCornersAll(radius: 8)
    }
}
