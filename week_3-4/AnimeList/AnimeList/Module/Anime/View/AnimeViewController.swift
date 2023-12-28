import UIKit
import RxCocoa
import RxSwift
import SkeletonView
import Hero

class AnimeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        bindData()
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    let disposeBag = DisposeBag()
    let userAnimeVM = UserAnimeViewModel.shared
    var userAnimes: [UserAnimeEntity] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    var selectedFilterIndex = 4 {
        didSet{
            tableView.reloadData()
        }
    }
    var filterString: String = "A-Z" {
        didSet{
            tableView.reloadData()
        }
    }
}

extension AnimeViewController {
    
    func configureUI(){
        appBar.createAppBar()
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(AnimeListCell.self)
        tableView.registerCellWithNib(AnimeSearchFilterCell.self)
    }
    
    func loadData(){
        if let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults(){
            UserAnimeViewModel.shared.getUserAnime(userId: userId){[weak self] finish in
                if (finish){
                    self?.tableView.hideSkeleton()
                }
            }
        }
    }
    
    func bindData(){
        tableView.showAnimatedGradientSkeleton()
        userAnimeVM.userAnime
            .subscribe(onNext: {[weak self] in self?.userAnimes = $0
            })
            .disposed(by: disposeBag)
    }
}

extension AnimeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return userAnimes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AnimeSearchFilterCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.filterButton.setTitle(userAnimeVM.filterData[selectedFilterIndex], for: .normal)
            return cell
        case 1:
            let data = userAnimes[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AnimeListCell
            cell.selectionStyle = .none
            if let id = data.anime.malId {
                cell.urlImage.hero.id = String(id)
            }
            cell.initialSetup(data: data)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
            let data = userAnimes[indexPath.row]
            let vc = DetailAnimeViewController()
            vc.id = data.id
            vc.malId = data.anime.malId
            vc.hidesBottomBarWhenPushed = true
            navigationController?.hero.isEnabled = true
            navigationController?.pushViewController(vc, animated: true)
            vc.navigationController?.isNavigationBarHidden = true
        }
    }
}

extension AnimeViewController: SkeletonTableViewDataSource{
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 9
        default:
            return 0
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0:
            return String(describing: AnimeSearchFilterCell.self)
        case 1:
            return String(describing: AnimeListCell.self)
        default:
            return ""
        }
    }
}

extension AnimeViewController: AnimeSearchFilterCellDelegate, AnimeListCellDelegate, FilterPopUpDelegate{
    func didTapFilterIndex(index: Int) {
        selectedFilterIndex = index
        userAnimeVM.sortUserAnime(index: index)
    }
    
    func didTapFilterPopUp() {
        let vc = FilterPopUp()
        vc.delegate = self
        vc.view.alpha = 0.0
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
        UIView.animate(withDuration: 0.5) {
            vc.view.alpha = 1.0
        }
    }
    
    func didTapNavigation() {
        let vc = SearchViewController()
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
    
    func didTap(data: UserAnimeEntity) {
        let bottomSheetVC = UpdateListBottomSheet()
        bottomSheetVC.malId = data.anime.malId ?? 0
        bottomSheetVC.id = data.id
        bottomSheetVC.totalEpisode = data.anime.episodes
        bottomSheetVC.imageUrl = data.anime.images?.jpg?.imageUrl ?? ""
        bottomSheetVC.setContentHeight(bottomSheetVC.view.bounds.height)
        self.presentBottomSheet(contentViewController: bottomSheetVC)
    }
    
    func increamentEpisode(data: UserAnimeEntity) {
        self.userAnimeVM.updateUserAnime(body: UpdateUserAnimeParam(id: data.id, userScore: data.userScore, userEpisode: data.userEpisode + 1, watchStatus: data.watchStatus)){result in
            switch result {
            case .success:
                if let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults(){
                    self.userAnimeVM.getUserAnime(userId: userId){ result in }
                }
                break
            case .failure:
                break
            }
        }
    }
}
