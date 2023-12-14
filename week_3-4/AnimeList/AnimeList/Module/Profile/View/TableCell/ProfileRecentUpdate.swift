import UIKit
import RxSwift
import RxCocoa

class ProfileRecentUpdate: UITableViewCell {
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var viewAllUpdate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
    }
    
    private let disposeBag = DisposeBag()
    var userRecentUpdates: [UserRecentUpdateEntity] = []{
        didSet{
            tableView.reloadData()
        }
    }
}

extension ProfileRecentUpdate {
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(ProfileRecentUpdateItemCell.self)
    }
}

extension ProfileRecentUpdate: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRecentUpdates.count < 3 ? userRecentUpdates.count : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = userRecentUpdates[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileRecentUpdateItemCell
        cell.initialSetup(data: data)
        cell.selectionStyle = .none
        return cell
    }
}
