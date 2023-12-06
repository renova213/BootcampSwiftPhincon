import UIKit
import RxSwift
import RxCocoa

class ProfileRecentUpdate: UITableViewCell {
    
    @IBOutlet weak var viewAllUpdate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
    }
    
    private let disposeBag = DisposeBag()
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileRecentUpdateItemCell
        cell.initialSetup()
        cell.selectionStyle = .none
        return cell
    }
}
