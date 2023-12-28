import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class AnimeSchedulePagingViewController: UIViewController {
    
    
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
    
    var index: Int?
    private let disposeBag = DisposeBag()
    private let animeCalendarVM = AnimeScheduleViewModel()
    var animeCalendars: [AnimeEntity] = [] {
        didSet{
            tableView.reloadData()
        }
    }
}

extension AnimeSchedulePagingViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: AnimeScheduleTableCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animeCalendars.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = animeCalendars[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AnimeScheduleTableCell
        cell.selectionStyle = .none
        cell.initialSetup(data: data)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = animeCalendars[indexPath.row]
        let vc = DetailAnimeViewController()
        vc.malId = data.malId
        navigationController?.hero.isEnabled = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
}

extension AnimeSchedulePagingViewController {
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(AnimeScheduleTableCell.self)
    }
    
    func loadData(){
        switch index {
        case 0:
            animeCalendarVM.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "monday", limit: "15")), with: AnimeCalendarEnum.monday, resultType: AnimeResponse.self)
            break
        case 1:
            animeCalendarVM.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "tuesday", limit: "15")), with: AnimeCalendarEnum.tuesday, resultType: AnimeResponse.self)
            break
        case 2:
            animeCalendarVM.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "wednesday", limit: "15")), with: AnimeCalendarEnum.wednesday, resultType: AnimeResponse.self)
            break
        case 3:
            animeCalendarVM.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "thursday", limit: "15")), with: AnimeCalendarEnum.thursday, resultType: AnimeResponse.self)
            break
        case 4:
            animeCalendarVM.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "friday", limit: "15")), with: AnimeCalendarEnum.friday, resultType: AnimeResponse.self)
            break
        case 5:
            animeCalendarVM.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "unknown", limit: "15")), with: AnimeCalendarEnum.unknown, resultType: AnimeResponse.self)
            break
        case 6:
            animeCalendarVM.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "other", limit: "15")), with: AnimeCalendarEnum.other, resultType: AnimeResponse.self)
            break
        default:
            break
        }
    }
    
    func bindData(){
        animeCalendarVM.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.tableView.showAnimatedGradientSkeleton()
                break
            case .finished, .failed, .initial:
                self.tableView.hideSkeleton()
                break
            }
        }).disposed(by: disposeBag)
        
        if let index = self.index {
            switch index {
            case 0:
                animeCalendarVM.mondayAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
                break
            case 1:
                animeCalendarVM.tuesdayAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
                break
            case 2:
                animeCalendarVM.wednesdayAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
                break
            case 3:
                animeCalendarVM.thursdayAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
            case 4:
                animeCalendarVM.fridayAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
            case 5:
                animeCalendarVM.unknownAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
            case 6:
                animeCalendarVM.otherAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
                break
            default:
                break
            }
        }
    }
}
