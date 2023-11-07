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
        getVehicles()
        setUpTableView()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    var vehicles: [VehicleEntity] = [] {
        didSet {
            listViewTable.reloadData()
        }
    }
    
    var currentCellIndex: Int = 0 {
        didSet {
            listViewTable.reloadData()
        }
    }
    
    @IBAction func chooseVehicleButton(_ sender: Any) {
        
        self.navigationController?.setViewControllers( [MainTabBarViewController()], animated: true)
    }
}

extension VehicleViewController {
    func getVehicles() -> Void {
        let userId = UserViewModel.shared.getUser().id
        
        VehicleViewModel().getVehicles(userId: userId)
    }
}

extension VehicleViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.showsVerticalScrollIndicator = false
        
        let data = vehicles[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as VehicleCard
        cell.vehicleName.text = data.vehicleName
        cell.platNumber.text = data.platNumber

        if currentCellIndex == indexPath.row + 1 {
            if let mainColor = UIColor(named: "Main Color")?.withAlphaComponent(0.6) {
                cell.vehicleCard.backgroundColor = mainColor
            }
        }else{
            cell.vehicleCard.backgroundColor = UIColor.systemBackground
        }
        
        switch data.vehicleType {
        case "Car":
            cell.vehicleImage.image = UIImage(systemName: "car")
            return cell
        case "Bike":
            cell.vehicleImage.image = UIImage(systemName: "bicycle")
            return cell
        case "Bus":
            cell.vehicleImage.image = UIImage(systemName: "bus")
            return cell
        default:
            cell.vehicleImage.image = UIImage(systemName: "car")
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeCellCurrentIndex(index: indexPath.row)
    }
}

extension VehicleViewController{
    func changeCellCurrentIndex (index: Int) {
        currentCellIndex = index + 1;
    }
}

extension VehicleViewController {
    func setUpTableView(){
        listViewTable.delegate = self
        listViewTable.dataSource = self
        listViewTable.registerCellWithNib(VehicleCard.self)
    }
}
