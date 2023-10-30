//
//  DashboardViewController.swift
//  latihan_hari_5
//
//  Created by Phincon on 27/10/23.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        registerCell()
    }
    
    func registerCell(){
        listTableView.registerCellWithNib(DashboardUserInfo.self)
        listTableView.registerCellWithNib(DashboardChart.self)
        listTableView.registerCellWithNib(DashboardGasStation.self)
        listTableView.registerCellWithNib(DashboardUsedBBM.self)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let dashBoardUserInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardUserInfo
        let dashBoardChartCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardChart
        let DashboardGasStationCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardGasStation
        let DashboardUsedBBMCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardUsedBBM
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        tableView.allowsSelection = false
        
        switch indexPath.row {
        case 0:
            return dashBoardUserInfoCell
        case 1:
            return dashBoardChartCell
        case 2:
            return DashboardGasStationCell
        case 3:
            return DashboardUsedBBMCell
        default:
            return dashBoardUserInfoCell
        }
        
    }
}


