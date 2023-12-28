import UIKit
import RxSwift
import SkeletonView
import Hero

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var appBar: UIView!
    @IBOutlet weak var dashboardTableView: UITableView!
    
    weak var delegateTodayAnime: TodayAnimeDelegate?
    weak var delegateCurrentAnime: CurrentAnimeDelegate?

    private lazy var dashboardVM = DashboardViewModel.shared
    let disposeBag = DisposeBag()

    var currentAnime: [AnimeEntity] = [] {
        didSet {
            dashboardTableView.reloadData()
        }
    }

    var currentSeasonAnime: [AnimeEntity] = [] {
        didSet {
            dashboardTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
        loadData()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindData()
    }
}

extension DashboardViewController {
    func configureUI(){
        appBar.createAppBar()
    }
    
    func configureTableView() {
        DispatchQueue.main.async {
            self.dashboardTableView.isSkeletonable = true
        }

        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self

        let cellTypes: [UITableViewCell.Type] = [DashboardSearch.self, DashboardCategory.self, TodayAnime.self, CurrentSeasonAnime.self]
        cellTypes.forEach { type in
            dashboardTableView.registerCellWithNib(type)
        }
    }
    
    func loadData() {
        let scheduledParams = ScheduleParam(filter: Date.getCurrentDay().lowercased(), page: "1", limit: "6")
        dashboardVM.loadData(for: Endpoint.getScheduledAnime(params: scheduledParams), resultType: AnimeResponse.self)

        dashboardVM.loadData(for: Endpoint.getSeasonNow(params: SeasonNowParam(page: "1", limit: "6")), resultType: AnimeResponse.self)
    }
    
    private func refreshPopUp(message: String){
        let vc = RefreshPopUp()
        vc.setContentHeight(vc.view.bounds.height)
        vc.errorLabel.text = message
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
}

extension DashboardViewController {
    func bindData() {
        dashboardVM.currentAnime.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                self.currentAnime = $0
            })
            .disposed(by: disposeBag)

        dashboardVM.currentSeasonAnime.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.currentSeasonAnime = $0
            })
            .disposed(by: disposeBag)

        dashboardVM.loadingState.asObservable()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .initial, .loading:
                    self.dashboardTableView.showAnimatedGradientSkeleton()
                    break
                case .finished:
                    self.dashboardTableView.hideSkeleton()
                    break
                case .failed:
                    self.refreshPopUp(message: self.dashboardVM.errorMessage.value)
                    break
                }
                
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
        let cellTypes: [String] = [String(describing: DashboardSearch.self), String(describing: DashboardCategory.self), String(describing: TodayAnime.self), String(describing: CurrentSeasonAnime.self)]
        return cellTypes[indexPath.section]
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
            let cell: DashboardSearch = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.delegate = self
            return cell
        case 1:
            let cell: DashboardCategory = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.delegate = self
            return cell
        case 2:
            let cell: TodayAnime = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.currentAnime = currentAnime
            cell.showMoreButton.setTitle(.localized("others"), for: .normal)
            cell.delegate = self
            return cell
        case 3:
            let cell: CurrentSeasonAnime = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.currentSeasonAnime = currentSeasonAnime
            cell.moreButton.setTitle(.localized("others"), for: .normal)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension DashboardViewController: UIScrollViewDelegate {
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

extension DashboardViewController: TodayAnimeDelegate, DashboardSearchDelegate, CurrentAnimeDelegate, DashboardCategoryItemDelegate, RefreshPopUpDelegate {
    func didTapRefresh() {
        self.dismiss(animated: false)
        loadData()
    }
    
    func didTapTodayAnime(malId: Int) {
        navigateToDetailAnimeViewController(malId: malId)
    }

    func didTapNavigation() {
        navigateToShowMoreViewController(type: "currentAnime")
    }

    func didSelectCell() {
        navigateToView(view: SearchViewController())
    }

    func didTapCurrentAnime(malId: Int) {
        navigateToDetailAnimeViewController(malId: malId)
    }

    func didTapShowMoreCurrentAnime() {
        navigateToShowMoreViewController(type: "seasonNow")
    }

    func didTapNavigateRankAnime(index: Int) {
        switch index {
        case 0:
            navigateToView(view: TopAnimeViewController())
            break
        case 1:
            navigateToView(view: TopMangaViewController())
            break
        case 2:
            navigateToView(view: AnimeSeasonViewController())
            break
        case 3:
            navigateToView(view: AnimeScheduleViewController())
            break
        default:
            break
        }
    }

    private func navigateToDetailAnimeViewController(malId: Int) {
        let vc = DetailAnimeViewController()
        vc.malId = malId
        navigationController?.hero.isEnabled = true
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }

    private func navigateToShowMoreViewController(type: String) {
        let vc = ShowMoreViewController()
        vc.typeGet = type
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }

    private func navigateToView(view: UIViewController) {
        let vc = view
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
}
