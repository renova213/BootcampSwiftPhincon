import UIKit
import RxSwift

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var dashboardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFetchViewModel()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindFetchViewModel()
    }
    
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
}

extension DashboardViewController {
    
    func getFetchViewModel(){
        AnimeViewModel.shared.getCurrentAnime()
        AnimeViewModel.shared.getCurrentSeasonAnime()
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

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource, DashboardSearchDelegate {
   
    func configureTableView(){
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
        dashboardTableView.registerCellWithNib(DashboardSearch.self)
        dashboardTableView.registerCellWithNib(DashboardCategory.self)
        dashboardTableView.registerCellWithNib(TodayAnime.self)
        dashboardTableView.registerCellWithNib(CurrentSeasonAnime.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let dashboardSearch = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardSearch

            dashboardSearch.delegate = self

            return dashboardSearch
        case 1:
            let dashboardCategory = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardCategory
            return dashboardCategory
        case 2:
            let todayAnime = tableView.dequeueReusableCell(forIndexPath: indexPath) as TodayAnime
            todayAnime.currentAnime = currentAnime
            return todayAnime
        case 3:
            let currentSeason = tableView.dequeueReusableCell(forIndexPath: indexPath) as CurrentSeasonAnime
            currentSeason.currentSeasonAnime = currentSeasonAnime
            return currentSeason
        default:
            return UITableViewCell()
        }
    }
    
    func didSelectCell(text: String) {
        
        let searchViewController = SearchViewController()

    
        navigationController?.pushViewController(searchViewController, animated: true)
        searchViewController.navigationController?.isNavigationBarHidden = true
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

