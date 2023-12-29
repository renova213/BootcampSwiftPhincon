import UIKit
import RxSwift
import RxCocoa
import SkeletonView
import Lottie

class TopAnimePagingView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        bindData()
        configureTableView()
        emptyStateAnimationView.loopMode = .loop
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableView.hideEmptyStateAnimation(animationView: emptyStateAnimationView)
    }
    
    private let disposeBag = DisposeBag()
    private let emptyStateAnimationView = LottieAnimationView(name: "empty")
    
    var topAnimes: [AnimeEntity] = []
    
    var index:Int?
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(TopAnimeTableCell.self)
    }
    
    private func loadData(){
        switch index {
        case 0:
            TopAnimeViewModel.shared.loadData(for: Endpoint.getTopAnime(params: TopAnimeParam(filter: "airing", limit: 15)), with: TopAnimeEnum.airing, resultType: AnimeResponse.self)
            break
        case 1:
            TopAnimeViewModel.shared.loadData(for: Endpoint.getTopAnime(params: TopAnimeParam(filter: "upcoming", limit: 15)), with: TopAnimeEnum.upcoming, resultType: AnimeResponse.self)
            break
        case 2:
            TopAnimeViewModel.shared.loadData(for: Endpoint.getTopAnime(params: TopAnimeParam(filter: "bypopularity", limit: 15)), with: TopAnimeEnum.popularity, resultType: AnimeResponse.self)
            break
        case 3:
            TopAnimeViewModel.shared.loadData(for: Endpoint.getTopAnime(params: TopAnimeParam(filter: "favorite", limit: 15)), with: TopAnimeEnum.favorite, resultType: AnimeResponse.self)
            break
        default:
            break
        }
    }
    
    private func bindData(){
        TopAnimeViewModel.shared.loadingState.subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case .initial:
                break
            case .empty:
                self.tableView.hideSkeleton()
                self.tableView.showEmptyStateAnimation(animationView: self.emptyStateAnimationView)
                break
            case .loading :
                self.tableView.showAnimatedGradientSkeleton()
                self.tableView.hideEmptyStateAnimation(animationView: self.emptyStateAnimationView)
                break
            case .finished:
                self.tableView.hideSkeleton()
                self.tableView.hideEmptyStateAnimation(animationView: self.emptyStateAnimationView)
                self.tableView.reloadData()
                break
            case .failed:
                self.refreshPopUp(message: TopAnimeViewModel.shared.errorMessage.value)
                break
            }
        }).disposed(by: disposeBag)
        
        if let index = self.index {
            switch index {
            case 0:
                TopAnimeViewModel.shared.topAiringAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.topAnimes = animes
                    }
                }).disposed(by: disposeBag)
                break
            case 1:
                TopAnimeViewModel.shared.topUpcomingAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.topAnimes = animes
                    }
                }).disposed(by: disposeBag)
                break
            case 2:
                TopAnimeViewModel.shared.topPopularityAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.topAnimes = animes
                    }
                }).disposed(by: disposeBag)
                break
            case 3:
                TopAnimeViewModel.shared.topFavoriteAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.topAnimes = animes
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
        vc.setContentHeight(vc.view.bounds.height)
        vc.errorLabel.text = message
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
}

extension TopAnimePagingView: UITableViewDelegate, SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: TopAnimeTableCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topAnimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = topAnimes[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TopAnimeTableCell
        cell.selectionStyle = .none
        cell.initialSetup(data: data, index: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = topAnimes[indexPath.row]
        let vc = DetailAnimeViewController()
        vc.malId = data.malId
        navigationController?.hero.isEnabled = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
}

extension TopAnimePagingView: RefreshPopUpDelegate {
    func didTapRefresh() {  
        self.dismiss(animated: false)
        loadData()
    }
}
