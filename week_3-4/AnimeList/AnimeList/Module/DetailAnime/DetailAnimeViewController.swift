//
//  DetailAnimeViewController.swift
//  AnimeList
//
//  Created by Phincon on 15/11/23.
//

import UIKit
import RxSwift
import RxCocoa

class DetailAnimeViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var sourceButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addToListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    var animeData:AnimeEntity?
    private let disposeBag = DisposeBag()
}

extension DetailAnimeViewController{
    private func configureUI() {
        backButtonGesture()
        sourceButtonGesture()
        configureTableView()
        addToListButton.roundCornersAll(radius: 10)
    }
    
    private func backButtonGesture(){
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        ).disposed(by: disposeBag)
    }
    
    private func sourceButtonGesture(){
        sourceButton.rx.tap.subscribe(onNext: {_ in
            if let urlData = self.animeData?.url{
                if let url = URL(string: urlData) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }).disposed(by: disposeBag)
    }
}

extension DetailAnimeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(AnimeDetailInfo.self)
        tableView.registerCellWithNib(DetailAnimeTrailer.self)
        tableView.registerCellWithNib(DetailAnimeMoreInfo.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let animeDetailInfo = tableView.dequeueReusableCell(forIndexPath: indexPath) as AnimeDetailInfo
            
            if let data = animeData {
                animeDetailInfo.initialSetup(data: data)
            }
            
            return animeDetailInfo
        case 1:
            let animeDetailTrailer = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeTrailer
            animeDetailTrailer.initialYoutubeId(youtubeId: animeData?.trailer.youtubeId ?? "")
            return animeDetailTrailer
        
        case 2:
            let detailAnimeMoreInfo = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeMoreInfo
            return detailAnimeMoreInfo
            
        default:
            return UITableViewCell()
        }
    }
}
