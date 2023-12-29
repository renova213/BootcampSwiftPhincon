import UIKit
import RxSwift
import RxCocoa
import SkeletonView
import Lottie

class AnimeSchedulePagingViewController: UIViewController {
    
    
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
    
    var index: Int?
    private let disposeBag = DisposeBag()
    private var animeCalendars: [AnimeEntity] = []
    private let emptyStateAnimationView = LottieAnimationView(name: "empty")
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(AnimeScheduleTableCell.self)
    }
    
    private func loadData(){
        switch index {
        case 0:
            AnimeScheduleViewModel.shared.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "monday", limit: "15")), with: AnimeCalendarEnum.monday, resultType: AnimeResponse.self)
            break
        case 1:
            AnimeScheduleViewModel.shared.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "tuesday", limit: "15")), with: AnimeCalendarEnum.tuesday, resultType: AnimeResponse.self)
            break
        case 2:
            AnimeScheduleViewModel.shared.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "wednesday", limit: "15")), with: AnimeCalendarEnum.wednesday, resultType: AnimeResponse.self)
            break
        case 3:
            AnimeScheduleViewModel.shared.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "thursday", limit: "15")), with: AnimeCalendarEnum.thursday, resultType: AnimeResponse.self)
            break
        case 4:
            AnimeScheduleViewModel.shared.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "friday", limit: "15")), with: AnimeCalendarEnum.friday, resultType: AnimeResponse.self)
            break
        case 5:
            AnimeScheduleViewModel.shared.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "unknown", limit: "15")), with: AnimeCalendarEnum.unknown, resultType: AnimeResponse.self)
            break
        case 6:
            AnimeScheduleViewModel.shared.loadData(for: Endpoint.getScheduledAnime(params: ScheduleParam(filter: "other", limit: "15")), with: AnimeCalendarEnum.other, resultType: AnimeResponse.self)
            break
        default:
            break
        }
    }
    
    private func bindData(){
        AnimeScheduleViewModel.shared.loadingState.asObservable().subscribe(onNext: {[weak self] state in
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
                self.refreshPopUp(message: AnimeScheduleViewModel.shared.errorMessage.value)
                break
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
                AnimeScheduleViewModel.shared.mondayAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
                break
            case 1:
                AnimeScheduleViewModel.shared.tuesdayAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
                break
            case 2:
                AnimeScheduleViewModel.shared.wednesdayAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
                break
            case 3:
                AnimeScheduleViewModel.shared.thursdayAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
            case 4:
                AnimeScheduleViewModel.shared.fridayAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
            case 5:
                AnimeScheduleViewModel.shared.unknownAnime.subscribe({[weak self] data in
                    guard let self = self else { return }
                    if let animes = data.element {
                        self.animeCalendars = animes
                    }
                }).disposed(by: disposeBag)
            case 6:
                AnimeScheduleViewModel.shared.otherAnime.subscribe({[weak self] data in
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
    
    private func refreshPopUp(message: String){
        let vc = RefreshPopUp()
        vc.delegate = self
        self.present(vc, animated: false)
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

extension AnimeSchedulePagingViewController: RefreshPopUpDelegate {
    func didTapRefresh() {
        loadData()
        self.dismiss(animated: false)
    }
}
