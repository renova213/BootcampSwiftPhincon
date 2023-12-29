import UIKit
import SkeletonView
import RxSwift
import RxCocoa
import Lottie

class TopMangaPagingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadData()
        bindData()
        emptyStateAnimationView.loopMode = .loop
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.hideEmptyStateAnimation(animationView: emptyStateAnimationView)
    }
    
    private let topMangaVM = TopMangaViewModel()
    private let disposeBag = DisposeBag()
    var topMangas: [MangaEntity] = []
    var index:Int?
    private let emptyStateAnimationView = LottieAnimationView(name: "empty")
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(TopMangaTableCell.self)
    }
    
    private func loadData(){
        switch index {
        case 0:
            topMangaVM.loadData(for: Endpoint.getTopManga(params: TopMangaParam(type: "manga", filter: "publishing", limit: 15)), with: TopMangaEnum.publishing, resultType: MangaResponse.self)
            break
        case 1:
            topMangaVM.loadData(for: Endpoint.getTopManga(params: TopMangaParam(type: "manga", filter: "upcoming", limit: 15)), with: TopMangaEnum.upcoming, resultType: MangaResponse.self)
            break
        case 2:
            topMangaVM.loadData(for: Endpoint.getTopManga(params: TopMangaParam(type: "manga", filter: "bypopularity", limit: 15)), with: TopMangaEnum.popularity, resultType: MangaResponse.self)
            break
        case 3:
            topMangaVM.loadData(for: Endpoint.getTopManga(params: TopMangaParam(type: "manga", filter: "favorite", limit: 15)), with: TopMangaEnum.favorite, resultType: MangaResponse.self)
            break
        default:
            break
        }
    }
    
    private func bindData(){
        topMangaVM.loadingState.subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading :
                self.tableView.hideEmptyStateAnimation(animationView: self.emptyStateAnimationView)
                self.tableView.showAnimatedGradientSkeleton()
                break
            case .finished:
                self.tableView.hideSkeleton()
                self.tableView.hideEmptyStateAnimation(animationView: self.emptyStateAnimationView)
                self.tableView.reloadData()
                break
            case .failed:
                self.refreshPopUp(message: self.topMangaVM.errorMessage.value)
            case .empty:
                self.tableView.hideSkeleton()
                self.tableView.showEmptyStateAnimation(animationView: self.emptyStateAnimationView)
            case .initial:
                break
            }
        }).disposed(by: disposeBag)
        
        if let index = self.index {
            switch index {
            case 0:
                topMangaVM.topPublishingManga.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let mangas = data.element {
                        self.topMangas = mangas
                    }
                }).disposed(by: disposeBag)
                break
            case 1:
                topMangaVM.topUpcomingManga.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let mangas = data.element {
                        self.topMangas = mangas
                    }
                }).disposed(by: disposeBag)
                break
            case 2:
                topMangaVM.topPopularityManga.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let mangas = data.element {
                        self.topMangas = mangas
                    }
                }).disposed(by: disposeBag)
                break
            case 3:
                topMangaVM.topFavoriteManga.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let mangas = data.element {
                        self.topMangas = mangas
                    }
                }).disposed(by: disposeBag)
                break
            default:
                break
            }
        }
    }
    
    private func refreshPopUp(message: String){
        let vc = RefreshPopUp()
        vc.delegate = self
        vc.errorLabel.text = message
        self.present(vc, animated: false)
    }
}

extension TopMangaPagingViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: TopMangaTableCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topMangas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = topMangas[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TopMangaTableCell
        cell.selectionStyle = .none
        cell.initialSetup(data: data, index: indexPath.row)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = topMangas[indexPath.row]
        let vc = DetailMangaViewController()
        vc.malId = data.malId
        navigationController?.hero.isEnabled = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
}

extension TopMangaPagingViewController: RefreshPopUpDelegate {
    func didTapRefresh() {
        loadData()
        self.dismiss(animated: false)
    }
}
