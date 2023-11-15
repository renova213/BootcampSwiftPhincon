//
//  DetailAnimeViewController.swift
//  AnimeList
//
//  Created by Phincon on 15/11/23.
//

import UIKit

class DetailAnimeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    var animeData:AnimeEntity?
}

extension DetailAnimeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(AnimeDetailInfo.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
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
        default:
            return UITableViewCell()
        }
    }
}
