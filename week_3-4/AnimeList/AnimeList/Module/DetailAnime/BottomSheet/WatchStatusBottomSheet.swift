import UIKit

class WatchStatusBottomSheet: UIViewController {
    
    @IBOutlet weak var statusTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }
    
    func setContentHeight(_ height: CGFloat) {
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

extension WatchStatusBottomSheet: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailAnimeViewModel.shared.watchStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexWatchStatus = 0
        
        let data = DetailAnimeViewModel.shared.watchStatus[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as WatchStatusItem
        cell.selectionStyle = .none
        cell.titleLabel.text = data
        if (indexWatchStatus == indexPath.row){
            cell.radioImage.image = UIImage(named: "radio_true")
        }else{
            cell.radioImage.image = UIImage(named: "radio_false")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureTable(){
        statusTable.dataSource = self
        statusTable.delegate = self
        statusTable.registerCellWithNib(WatchStatusItem.self)
    }
}
