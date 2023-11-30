import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class TopAnimePagingView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindData()
    }
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let topAnimeVM = TopAnimeViewModel()
    private let disposeBag = DisposeBag()
    var topAnimes: [AnimeEntity]? {
        didSet{
            tableView.reloadData()
        }
    }
    var index:Int?
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
        return topAnimes?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = topAnimes{
            let data = data[indexPath.row]
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TopAnimeTableCell
            cell.selectionStyle = .none
            cell.initialSetup(data: data, index: indexPath.row)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = topAnimes {
            let data = data[indexPath.row]
            let vc = DetailAnimeViewController()
            vc.malId = data.malId
            navigationController?.hero.isEnabled = true
            navigationController?.pushViewController(vc, animated: true)
            vc.navigationController?.isNavigationBarHidden = true
        }
    }
}

extension TopAnimePagingView {
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(TopAnimeTableCell.self)
    }
    
    func loadData(){
        switch index {
        case 0:
            topAnimeVM.loadData(for: Endpoint.getTopAnime(params: TopAnimeParam(filter: "airing", page: 1)), with: TopAnimeEnum.airing, resultType: AnimeResponse.self)
            break
        case 1:
            topAnimeVM.loadData(for: Endpoint.getTopAnime(params: TopAnimeParam(filter: "upcoming", page: 1)), with: TopAnimeEnum.upcoming, resultType: AnimeResponse.self)
            break
        case 2:
            topAnimeVM.loadData(for: Endpoint.getTopAnime(params: TopAnimeParam(filter: "bypopularity", page: 1)), with: TopAnimeEnum.popularity, resultType: AnimeResponse.self)
            break
        case 3:
            topAnimeVM.loadData(for: Endpoint.getTopAnime(params: TopAnimeParam(filter: "favorite", page: 1)), with: TopAnimeEnum.favorite, resultType: AnimeResponse.self)
            break
        default:
            break
        }
    }
    
    func bindData(){
        topAnimeVM.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading :
                self.tableView.showAnimatedGradientSkeleton()
                break
            case .finished, .failed, .notLoad:
                self.tableView.hideSkeleton()
                break
            }
        }).disposed(by: disposeBag)
        
        if let index = self.index {
            switch index {
            case 0:
                topAnimeVM.topAiringAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.topAnimes = animes
                    }
                }).disposed(by: disposeBag)
                break
            case 1:
                topAnimeVM.topUpcomingAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.topAnimes = animes
                    }
                }).disposed(by: disposeBag)
                break
            case 2:
                topAnimeVM.topPopularityAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.topAnimes = animes
                    }
                }).disposed(by: disposeBag)
                break
            case 3:
                topAnimeVM.topFavoriteAnime.subscribe({[weak self] data in
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
}
