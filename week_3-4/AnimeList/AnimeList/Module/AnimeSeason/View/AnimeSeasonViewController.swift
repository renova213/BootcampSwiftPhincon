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
        bindData()
    }
    
    private let disposeBag = DisposeBag()
    private var animeSeasons: [AnimeEntity] = []
    
    private func configureUI(){
        filterButton.roundCornersAll(radius: 5)
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(AnimeSeasonTableCell.self)
    }
    
    private func buttonGesture() {
        backButton.rx.tap.subscribe(onNext: {_ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        ).disposed(by: disposeBag)
        filterButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.presentFloatingPanel()
        }
        ).disposed(by: disposeBag)
    }
    
    private func loadData(){
        let japanTimeZone = TimeZone(identifier: "Asia/Tokyo")!
        let currentSeason = Date.currentSeason(in: japanTimeZone)
        
        AnimeSeasonViewModel.shared.loadData(
            for: Endpoint.getSeason(params: AnimeSeasonParam(year: Date.getCurrentYear(), season: currentSeason)),
            resultType: AnimeSeasonResponse.self,
            sortIndex: 0
        )
        if let timeZone = TimeZone(identifier: "Asia/Tokyo"){
            AnimeSeasonViewModel.shared.changeTitleAppBar(title: "\(Date.currentSeason(in: timeZone)) \(Date.getCurrentYear())".capitalized)
        }
    }
    
    private func bindData(){
        AnimeSeasonViewModel.shared.loadingState.asObservable()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading :
                    self.tableView.showAnimatedGradientSkeleton()
                    break
                case .finished:
                    self.tableView.hideSkeleton()
                    self.tableView.reloadData()
                    break
                case .failed:
                    self.refreshPopUp(message: AnimeSeasonViewModel.shared.errorMessage.value)
                    break
                case .empty:
                    break
                case .initial:
                    break
                }
            })
            .disposed(by: disposeBag)
        AnimeSeasonViewModel.shared.animeSeasons.asObservable().subscribe({[weak self] data in
            guard let self = self else { return }
            self.animeSeasons = data.element ?? []
        }).disposed(by: disposeBag)
        AnimeSeasonViewModel.shared.titleAppBar.subscribe(onNext: {[weak self] title in
            guard let self = self else { return }
            self.titleLabel.text = title
        }).disposed(by: disposeBag)
    }
    
    private func refreshPopUp(message: String){
        let vc = RefreshPopUp()
        vc.delegate = self
        vc.errorLabel.text = message
        self.present(vc, animated: false)
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

extension AnimeSeasonViewController: AnimeSeasonContentViewControllerDelegate{
    func didConfirm(sortIndex: Int, season: String, year: Int) {
        AnimeSeasonViewModel.shared.loadData(
            for: Endpoint.getSeason(params: AnimeSeasonParam(year: year, season: season)),
            resultType: AnimeSeasonResponse.self,
            sortIndex: sortIndex
        )
        AnimeSeasonViewModel.shared.changeTitleAppBar(title: "\(season) \(year)".capitalized)
    }
}

extension AnimeSeasonViewController: RefreshPopUpDelegate {
    func didTapRefresh() {
        loadData()
        self.dismiss(animated: false)
    }
}
