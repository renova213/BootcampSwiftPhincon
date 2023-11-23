import UIKit
import RxSwift
import SkeletonView
import Hero

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var dashboardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindFetchViewModel()
        getFetchViewModel()
    }
    
    weak var delegateTodayAnime: TodayAnimeDelegate?
    weak var delegateCurrentAnime: CurrentAnimeDelegate?
    
    let disposeBag = DisposeBag()
    var currentAnime: [AnimeEntity] = []{
        didSet{
            dashboardTableView.reloadData()
        }
    }
    var currentSeasonAnime: [AnimeEntity] = []{
        didSet{
            dashboardTableView.reloadData()
        }
    }
    
    func configureTableView(){
        DispatchQueue.main.async {
            self.dashboardTableView.isSkeletonable = true
        }
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
        dashboardTableView.registerCellWithNib(DashboardSearch.self)
        dashboardTableView.registerCellWithNib(DashboardCategory.self)
        dashboardTableView.registerCellWithNib(TodayAnime.self)
        dashboardTableView.registerCellWithNib(CurrentSeasonAnime.self)
    }
}

extension DashboardViewController {
    
    func getFetchViewModel(){
        if(DashboardViewModel.shared.isFirstFetchData.value){
            DashboardViewModel.shared.changeFirstFetchData(bool: false)
            self.dashboardTableView.showAnimatedGradientSkeleton()
            
            AnimeViewModel.shared.getCurrentAnime(limit: "6", page: "1"){ finish in
                if (finish){
                    self.dashboardTableView.hideSkeleton()
                }
            }
            AnimeViewModel.shared.getCurrentSeasonAnime(limit: "6", page: "1")
        }
    }
    
    func bindFetchViewModel() {
        AnimeViewModel.shared.currentAnime
            .subscribe(onNext: { [weak self] i in
                
                self?.currentAnime = i
            })
            .disposed(by: disposeBag)
        
        AnimeViewModel.shared.currentSeasonAnime
            .subscribe(onNext: { [weak self] i in
                
                self?.currentSeasonAnime = i
            })
            .disposed(by: disposeBag)
    }
}

extension DashboardViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0:
            return String(describing: DashboardSearch.self)
        case 1:
            return String(describing: DashboardCategory.self)
        case 2:
            return String(describing: TodayAnime.self)
        case 3:
            return String(describing: CurrentSeasonAnime.self)
        default:
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardSearch
            
            cell.delegate = self
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardCategory
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TodayAnime
            cell.currentAnime = currentAnime
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CurrentSeasonAnime
            cell.currentSeasonAnime = currentSeasonAnime
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        let threshold: CGFloat = 100
        
        if yOffset > threshold {
            tabBarController?.tabBar.alpha = 0
        } else {
            tabBarController?.tabBar.alpha = 1
        }
    }
}

extension DashboardViewController: TodayAnimeDelegate{
    func didTapTodayAnime(malId: Int) {
        let vc = DetailAnimeViewController()
        vc.malId = malId
        navigationController?.hero.isEnabled = true
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
    
    func didTapNavigation() {
        let vc = ShowMoreViewController()
        vc.typeGet = "currentAnime"
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
}

extension DashboardViewController: DashboardSearchDelegate {
    func didSelectCell() {
        let vc = SearchViewController()
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
}

extension DashboardViewController: CurrentAnimeDelegate {
    func didTapCurrentAnime(malId: Int) {
        let vc = DetailAnimeViewController()
        vc.malId = malId
        vc.hidesBottomBarWhenPushed = true
        navigationController?.hero.isEnabled = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
    
    func didTapShowMoreCurrentAnime() {
        let vc = ShowMoreViewController()
        vc.typeGet = "seasonNow"
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
}

extension DashboardViewController: DashboardCategoryDelegate{
    func didTapNavigateRankAnime() {
        let vc = RankAnimeViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
}
