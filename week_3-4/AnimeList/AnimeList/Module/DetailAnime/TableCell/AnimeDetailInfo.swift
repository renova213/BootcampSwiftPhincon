//
//  AnimeDetailInfo.swift
//  AnimeList
//
//  Created by Phincon on 15/11/23.
//

import UIKit
import RxSwift
import RxCocoa

class AnimeDetailInfo: UITableViewCell {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var imageBorderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyleComponent()
        configureCollection()
    }
    
    var imageWidthConstraint: NSLayoutConstraint!
    var fullDescription = ""
    var isExpanded = BehaviorRelay<Bool>(value: false)
    let disposeBag = DisposeBag()
    let genres = ["Drama", "Romance", "Supernatural", "School"]
    
    func configureStyleComponent(){
        imageBorderView.layer.borderWidth = 1.0
        imageBorderView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }
    
    func initialSetup(data: AnimeEntity){
        
        if let imageURL = URL(string: data.images?.jpg?.imageUrl ?? "") {
            self.urlImage.kf.setImage(with: imageURL, placeholder: UIImage(named: "ImagePlaceholder"))
        }
        
        titleLabel.text = data.title ?? "-"
        
        statusLabel.text = data.status ?? "-"
        
        durationLabel.text = data.duration ?? "-"
        
        if let score = data.score {
            scoreLabel.text = String(score)
        }else{
            scoreLabel.text = "-"
        }
        
        if let synopsis = data.synopsis {
            synopsisLabel.text = synopsis
        }else{
            synopsisLabel.text = "-"
        }
        
        if let rank = data.rank {
            rankLabel.text = "#\(String(rank))"
        }else{
            rankLabel.text = "-"
        }
        
        if let popularity = data.popularity {
            popularityLabel.text = "#\(String(popularity))"
        }else{
            popularityLabel.text = "-"
        }
        
        if let members = data.members {
            membersLabel.text = String(members)
        }else{
            membersLabel.text = "-"
        }
        
        if let favorite = data.favorite {
            favoriteLabel.text = String(favorite)
        }else{
            favoriteLabel.text = "-"
        }
    }
}

extension AnimeDetailInfo: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func configureCollection(){
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        genreCollectionView.registerCellWithNib(AnimeGenreItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimeGenreItem", for: indexPath) as! AnimeGenreItem
        
        cell.initialSetup(genre: genres[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        label.text = genres[indexPath.row]
        label.sizeToFit()
        let extraSpacing: CGFloat = 12
        
        return CGSize(width: label.frame.width + extraSpacing, height: 40)
    }
}
