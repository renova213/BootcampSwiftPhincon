import UIKit
import RxSwift
import RxCocoa

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
        bindData()
    }
    
    private var profileStatsTabState = false {
        didSet{
            tableView.reloadData()
        }
    }
    
    private let profileVM = ProfileViewModel()
    
    private var toggleMinimizeFavorite: Bool = false {
        didSet{
            tableView.reloadData()
        }
    }
    
    private var toggleMinimizeRecentUpdate: Bool = false {
        didSet{
            tableView.reloadData()
        }
    }
}

extension ProfileViewController {
    func bindData(){
        profileVM.toggle.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            self.profileStatsTabState = state
        }).disposed(by: DisposeBag())
    }
    
    func configureUI(){
        appBar.createAppBar()
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(ProfileInfoCell.self)
        tableView.registerCellWithNib(ProfileStatsCell.self)
        tableView.registerCellWithNib(ProfileFavoriteCell.self)
        tableView.registerCellWithNib(ProfileRecentUpdate.self)    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
            cell.delegate = self
            cell.initialSetup(tabBarState: profileStatsTabState)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileRecentUpdate
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileFavoriteCell
            cell.selectionStyle = .none
            cell.initialChevronButton(state: toggleMinimizeFavorite)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension ProfileViewController: ProfileStatsCellDelegate, ProfileFavoriteCellDegelate {
    func minimizeFavorite() {
        toggleMinimizeFavorite = !toggleMinimizeFavorite
    }
    
    func didTapTab(state: Bool) {
        profileStatsTabState = state
    }
}
