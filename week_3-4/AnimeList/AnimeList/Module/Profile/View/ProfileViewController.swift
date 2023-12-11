import UIKit
import RxSwift
import RxCocoa
import FloatingPanel
import SkeletonView

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appBar: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        configureTableView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var profileStatsTabState = false {
        didSet{
            tableView.reloadData()
        }
    }
    
    private let profileVM = ProfileViewModel()
    
    var userData: UserEntity? {
        didSet{
            tableView.reloadData()
        }
    }
    
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
    
    private let disposeBag = DisposeBag()
}

extension ProfileViewController {
    func bindData(){
        profileVM.toggle.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            self.profileStatsTabState = state
        }).disposed(by: DisposeBag())
        
        profileVM.loadingState2.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading, .failed:
            self.tableView.showAnimatedGradientSkeleton()
                break
            case .finished, .notLoad:
                self.tableView.hideSkeleton()
            }
        }).disposed(by: disposeBag)
        
        profileVM.userData.asObservable().subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            if let responseData = data {
                self.userData = responseData
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
    }
    
    func loadData(){
        if let userId = profileVM.getUserIDFromUserDefaults(){
            profileVM.loadData(for: Endpoint.getUser(params: userId), resultType: UserResponse.self)
        }
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
        tableView.registerCellWithNib(ProfileRecentUpdate.self)
    }
}

extension ProfileViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let cellTypes: [String] = [String(describing: ProfileInfoCell.self), String(describing: ProfileStatsCell.self), String(describing: ProfileRecentUpdate.self), String(describing: ProfileFavoriteCell.self)]
        return cellTypes[indexPath.section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileInfoCell
            if let userData = self.userData {
                cell.initialSetup(data: userData)
            }
            cell.delegate = self
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

extension ProfileViewController: FloatingPanelControllerDelegate{
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return ProfileFloatingPanel()
    }
    
    func presentFloatingPanel(){
        let fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.isRemovalInteractionEnabled = true
        fpc.surfaceView.appearance.cornerRadius = 20
        let contentVC = ProfileSettingViewController()
        contentVC.delegate = self
        contentVC.hidesBottomBarWhenPushed = true
        contentVC.navigationController?.isNavigationBarHidden = true
        fpc.set(contentViewController: contentVC)
        self.present(fpc, animated: true, completion: nil)
    }
}

extension ProfileViewController: ProfileStatsCellDelegate, ProfileFavoriteCellDegelate, ProfileInfoCellDelegate, ProfileSettingViewControllerDelegate {
    func minimizeFavorite() {
        toggleMinimizeFavorite = !toggleMinimizeFavorite
    }
    
    func didTapTab(state: Bool) {
        profileStatsTabState = state
    }
    
    func didTapNavigationSetting() {
        self.presentFloatingPanel()
    }
    
    func didTapSignOut() {
        profileVM.deleteCredentials()
        let vc = AuthViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let appDelegate = windowScene.delegate as? SceneDelegate {
            let navigationController = UINavigationController(rootViewController: vc)
            appDelegate.window?.rootViewController = navigationController
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func didTapUpdateProfile() {
        let vc = UpdateProfileViewController()
        vc.view.alpha = 0.0
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
        UIView.animate(withDuration: 0.5) {
            vc.view.alpha = 1.0
        }
    }
}
