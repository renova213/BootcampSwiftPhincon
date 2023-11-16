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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.size.width)
        
        switch indexPath.section {
        case 0:
            let dashBoardUserInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardUserInfo
            dashBoardUserInfoCell.usernameLabel.text = UserViewModel.shared.getUser().username
            return dashBoardUserInfoCell
        case 1:
            let dashBoardChartCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardChart
            
            return dashBoardChartCell
        case 2:
            let DashboardGasStationCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardGasStation
            DashboardGasStationCell.delegate = self
            return DashboardGasStationCell
        case 3:
            let DashboardUsedBBMCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardUsedBBM
            return DashboardUsedBBMCell
        default:
            return UITableViewCell()
        }
    }
    
}

extension DashboardViewController: DashboardGasStationDelegate {
    func passData(withID id: String) {
        print(id)
        let vc = DetailGasStationViewController()
        vc.selectedId = id
        navigationController?.pushViewController(vc, animated: true)
    }
}
