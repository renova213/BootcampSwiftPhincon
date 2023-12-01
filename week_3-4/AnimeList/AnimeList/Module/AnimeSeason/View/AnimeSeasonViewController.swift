import UIKit
import RxSwift
import RxCocoa
import SkeletonView
import FloatingPanel

class AnimeSeasonViewController: UIViewController {
    var fpc: FloatingPanelController!
    
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
        cell.initialSetup(data: data)
        return cell
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
        animeSeasonVM.loadData(for: Endpoint.getSeasonNow(params: SeasonNowParam(page: "1", limit: "20")), resultType: AnimeResponse.self, index: 0)
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
    }
}

extension AnimeSeasonViewController: AnimeSeasonContentViewControllerDelegate{
    func didConfirm(index: Int) {
        animeSeasonVM.loadData(for: Endpoint.getSeasonNow(params: SeasonNowParam(page: "1", limit: "20")), resultType: AnimeResponse.self, index: index)
    }
}
