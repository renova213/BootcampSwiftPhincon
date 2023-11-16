import UIKit
import RxSwift

class VehicleViewController: UIViewController {
    
    @IBOutlet weak var listViewTable: UITableView!
    
    let disposeBag = DisposeBag()
    let vehicleViewModel = VehicleViewModel()
    var vehicles:[VehicleEntity]=[]{
        didSet{
            listViewTable.reloadData()
        }
    }
    var selectedVehicleId = ""
    var currentCellIndex: Int = 0 {
        didSet {
            listViewTable.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVehicles()
        setUpTableView()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindVehicles()
        bindSelectedVehicle()
    }
    
    @IBAction func chooseVehicleButton(_ sender: Any) {
        
        if selectedVehicleId.isEmpty {
            showEmptyVehicleAlert() // Tampilkan popup jika id kosong
        } else {
            let mainTabVC = MainTabBarViewController()
            self.navigationController?.pushViewController(mainTabVC, animated: true)
        }
    }
}

extension VehicleViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
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
        vehicleViewModel.selectedVehicle(id: vehicles[indexPath.row].id)
    }
}

extension VehicleViewController {
    
    func getVehicles() {
        let userId = UserViewModel.shared.getUser().id
        vehicleViewModel.getVehicles(userId: userId)
    }
    
    func setUpTableView(){
        listViewTable.delegate = self
        listViewTable.dataSource = self
        listViewTable.registerCellWithNib(VehicleCard.self)
    }
    
    func bindVehicles() {
        vehicleViewModel.vehicles
            .subscribe(onNext: { [weak self] vehicles in
                self?.vehicles = vehicles
            })
            .disposed(by: disposeBag)
    }
    
    func bindSelectedVehicle() {
        vehicleViewModel.selectedVehicleObservable
            .subscribe(onNext: { [weak self] selectedVehicle in
                self?.selectedVehicleId = selectedVehicle
            })
            .disposed(by: disposeBag)
    }
    
    func changeCellCurrentIndex (index: Int) {
        currentCellIndex = index + 1;
    }
    
    func showEmptyVehicleAlert() {
        let alert = UIAlertController(title: "Peringatan", message: "Pilih kendaraan terlebih dahulu..", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
