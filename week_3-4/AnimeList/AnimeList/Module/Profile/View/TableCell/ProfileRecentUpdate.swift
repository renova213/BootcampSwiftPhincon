import UIKit
import RxSwift
import RxCocoa

protocol ProfileRecentUpdateDelegate: AnyObject {
    func didNavigationMoreRecentUpdate()
}

class ProfileRecentUpdate: UITableViewCell {
    
    @IBOutlet weak var recentUpdateLabel: UILabel!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var viewAllUpdate: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recentUpdateView: UIView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
        configureUI()
        configureGesture()
    }
    
    weak var delegate: ProfileRecentUpdateDelegate?
    private let disposeBag = DisposeBag()
    var userRecentUpdates: [UserRecentUpdateEntity] = []{
        didSet{
            tableView.reloadData()
        }
    }
}

extension ProfileRecentUpdate {
    
    func configureUI(){
        recentUpdateView.roundCornersAll(radius: 8)
        recentUpdateLabel.text = .localized("recentUpdate")
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(ProfileRecentUpdateItemCell.self)
    }
    
    func configureGesture(){
        viewAllUpdate.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            
            self.delegate?.didNavigationMoreRecentUpdate()
        }).disposed(by: disposeBag)
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
