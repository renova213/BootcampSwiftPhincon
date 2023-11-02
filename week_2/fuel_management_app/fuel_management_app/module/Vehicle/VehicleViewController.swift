//
//  ViewController.swift
//  latihan_hari_4
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class VehicleViewController: UIViewController {
    
    @IBOutlet weak var listViewTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listViewTable.delegate = self
        listViewTable.dataSource = self
        listViewTable.registerCellWithNib(VehicleCard.self)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func chooseVehicleButton(_ sender: Any) {
        
        self.navigationController?.setViewControllers( [MainTabBarViewController()], animated: true)
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


extension VehicleViewController: UITableViewDelegate, UITableViewDataSource{
    
    // set number of section length
    func numberOfSections(in tableView: UITableView) -> Int {
        return VehicleEntity.vehicles.count
    }
    
    // set number of item section length
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VehicleEntity.vehicles[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return VehicleEntity.vehicles[section][0].vehicleType
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.showsVerticalScrollIndicator = false
        
        let data = VehicleEntity.vehicles[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as VehicleCard
        cell.vehicleName.text = data.vehicleName
        cell.platNumber.text = data.platNumber
        
        switch data.vehicleType {
        case "Car":
            cell.vehicleImage.image = UIImage(systemName: "car")
        case "Bike":
            cell.vehicleImage.image = UIImage(systemName: "bicycle")
        case "Bus":
            cell.vehicleImage.image = UIImage(systemName: "bus")
        default:
            cell.vehicleImage.image = UIImage(systemName: "car")
        }
        return cell
    }
}
