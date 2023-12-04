import UIKit
import RxSwift
import RxCocoa
import SkeletonView
import FloatingPanel

class AnimeSeasonViewController: UIViewController {
    var fpc: FloatingPanelController!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonGesture()
        configureTableView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindData()
    }
    
    private let disposeBag = DisposeBag()
    private let animeSeasonVM = AnimeSeasonViewModel()
    var animeSeasons: [AnimeEntity] = [] {
        didSet{
            tableView.reloadData()
        }
    }
}

extension AnimeSeasonViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        
        return String(describing: AnimeSeasonTableCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animeSeasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = animeSeasons[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AnimeSeasonTableCell
        cell.selectionStyle = .none
        cell.initialSetup(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = animeSeasons[indexPath.row]
        
        let vc = DetailAnimeViewController()
        vc.malId = data.malId
        navigationController?.hero.isEnabled = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
}

extension AnimeSeasonViewController: FloatingPanelControllerDelegate{
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return AnimeSeasonFloatingPanel()
    }
    
    func presentFloatingPanel(){
        let fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.isRemovalInteractionEnabled = true
        fpc.surfaceView.appearance.cornerRadius = 20
        let contentVC = AnimeSeasonContentViewController()
        contentVC.delegate = self
        fpc.set(contentViewController: contentVC)
        self.present(fpc, animated: true, completion: nil)
    }
}

extension AnimeSeasonViewController{
    func configureUI(){
        filterButton.roundCornersAll(radius: 5)
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(AnimeSeasonTableCell.self)
    }
    func buttonGesture() {
        backButton.rx.tap.subscribe(onNext: {_ in self.navigationController?.popToRootViewController(animated: true)
        }
        ).disposed(by: disposeBag)
        filterButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.presentFloatingPanel()
        }
        ).disposed(by: disposeBag)
    }
    func loadData(){
        let japanTimeZone = TimeZone(identifier: "Asia/Tokyo")!
        let currentSeason = Date.currentSeason(in: japanTimeZone)
        
        animeSeasonVM.loadData(
            for: Endpoint.getSeason(params: AnimeSeasonParam(year: Date.getCurrentYear(), season: currentSeason)),
            resultType: AnimeSeasonResponse.self,
            sortIndex: 0
        )
        if let timeZone = TimeZone(identifier: "Asia/Tokyo"){
            animeSeasonVM.changeTitleAppBar(title: "\(Date.currentSeason(in: timeZone)) \(Date.getCurrentYear())".capitalized)
        }
    }
    func bindData(){
        animeSeasonVM.loadingState.asObservable()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.filterButton.isHidden = true
                    self.tableView.showAnimatedGradientSkeleton()
                case .notLoad, .failed:
                    self.tableView.hideSkeleton()
                case .finished:
                    self.filterButton.isHidden = false
                    self.tableView.hideSkeleton()
                }
            })
            .disposed(by: disposeBag)
        animeSeasonVM.animeSeasons.asObservable().subscribe({[weak self] data in
            guard let self = self else { return }
            self.animeSeasons = data.element ?? []
        }).disposed(by: disposeBag)
        animeSeasonVM.titleAppBar.subscribe(onNext: {[weak self] title in
            guard let self = self else { return }
            self.titleLabel.text = title
        }).disposed(by: disposeBag)
    }
}

extension AnimeSeasonViewController: AnimeSeasonContentViewControllerDelegate{
    func didConfirm(sortIndex: Int, season: String, year: Int) {
        animeSeasonVM.loadData(
            for: Endpoint.getSeason(params: AnimeSeasonParam(year: year, season: season)),
            resultType: AnimeSeasonResponse.self,
            sortIndex: sortIndex
        )
        animeSeasonVM.changeTitleAppBar(title: "\(season) \(year)".capitalized)
    }
}
