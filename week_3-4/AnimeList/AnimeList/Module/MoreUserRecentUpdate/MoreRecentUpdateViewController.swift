import UIKit
import RxSwift
import RxCocoa

class MoreRecentUpdateViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureGesture()
        bindData()
        loadData()
    }
    
    var userRecentUpdates: [UserRecentUpdateEntity] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    private let disposeBag = DisposeBag()
    private let profileVM = ProfileViewModel()
}

extension MoreRecentUpdateViewController{
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(MoreUserRecentUpdateCell.self)
    }
    
    func configureGesture(){
        backButton.rx.tap.subscribe({[weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func loadData(){
        if let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults() {
            profileVM.loadData(for: Endpoint.getUserRecentUpdate(params: userId), resultType: UserRecentUpdateResponse.self)
        }
    }
    
    func bindData(){
        profileVM.userRecentUpdates.asObservable().subscribe(onNext: {[weak self] userUpdates in
            guard let self = self else { return }
            self.userRecentUpdates = userUpdates
        }).disposed(by: disposeBag)
    }
}

extension MoreRecentUpdateViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRecentUpdates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = userRecentUpdates[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MoreUserRecentUpdateCell
        cell.initialSetup(data: data)
        cell.selectionStyle = .none
        return cell
    }
}
