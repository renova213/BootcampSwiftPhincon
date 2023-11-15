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
    
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisLabe: UILabel!
    @IBOutlet weak var genreCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureStyleComponent()
        configureCollection()
    }
    
    var fullDescription = ""
    var isExpanded = BehaviorRelay<Bool>(value: false)
    let disposeBag = DisposeBag()
    
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
        
        if let synopsis = data.synopsis {
            synopsisLabe.text = synopsis
        }else{
            synopsisLabe.text = "-"
        }
    }
}

extension AnimeDetailInfo: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func configureCollection(){
        genreCollection.delegate = self
        genreCollection.dataSource = self
        genreCollection.registerCellWithNib(AnimeGenreItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimeGenreItem", for: indexPath) as! AnimeGenreItem

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 100, height: 40)
    }
}
