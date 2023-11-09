//
//  DashboardViewController.swift
//  AnimeList
//
//  Created by Phincon on 09/11/23.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var dashboardTableView: UITableView!
    override func viewDidLoad() {
        configureTableView()
        super.viewDidLoad()
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView(){
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
        dashboardTableView.registerCellWithNib(DashboardSearch.self)
        dashboardTableView.registerCellWithNib(DashboardCategory.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let dashboardSearch = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardSearch
            return dashboardSearch
        case 1:
            let dashboardCategory = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardCategory
            return dashboardCategory
        default:
            return UITableViewCell()
        }
    }
}
