import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appBar: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func configureUI(){
        appBar.createAppBar()
    }
}

extension ProfileViewController {
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(ProfileInfoCell.self)
        tableView.registerCellWithNib(ProfileStatsCell.self)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileInfoCell
            cell.initialSetup()
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileStatsCell
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}

