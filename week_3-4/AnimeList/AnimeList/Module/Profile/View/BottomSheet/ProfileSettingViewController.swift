import UIKit

protocol ProfileSettingViewControllerDelegate: AnyObject {
    func didTapSignOut()
    func didTapUpdateProfile()
}

class ProfileSettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private let profileVM = ProfileViewModel()
    weak var delegate: ProfileSettingViewControllerDelegate?
}

extension ProfileSettingViewController{
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(ProfileSettingCell.self)
    }
}

extension ProfileSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingItemEntity.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = SettingItemEntity.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileSettingCell
        if let image = UIImage(systemName: data.assetImage){
            cell.initialSetup(image: image, title: data.title)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.didTapUpdateProfile()
            self.dismiss(animated: false)
            break
        case 1:
            break
        case 2:
            break
        case 3:
            self.dismiss(animated: false)
            delegate?.didTapSignOut()
            break
        default:
            break
        }
    }
}
