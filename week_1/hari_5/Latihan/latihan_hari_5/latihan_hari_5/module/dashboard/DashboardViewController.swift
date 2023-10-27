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
        listTableView.delegate = self
        listTableView.dataSource = self
        
        registerCell()
    }
    
    func registerCell(){
        listTableView.registerCellWithNib(DashboardUserInfo.self)
        listTableView.registerCellWithNib(DashboardChart.self)
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return  tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardUserInfo
        case 1:
            return  tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardChart
        default:
            return  tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardChart
        }
        
    }
}


