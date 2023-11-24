import UIKit
import RxSwift
import RxCocoa
import SkeletonView
import Hero

class DetailAnimeViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var sourceButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addToListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.showAnimatedGradientSkeleton()
        addToListButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFetchViewModel()
        bindFetchViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    var malId: Int?
    var animeDetail: AnimeDetailData? {
        didSet{
            tableView.reloadData()
        }
    }
    var animeCharacter: [AnimeCharacterEntity] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    var animeStaff: [AnimeStaffEntity] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    var animeRecommendation: [AnimeRecommendationEntity] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    private let disposeBag = DisposeBag()
}

extension DetailAnimeViewController{
    private func configureUI() {
        buttonGesture()
        configureTableView()
        addToListButton.roundCornersAll(radius: 10)
    }
    
    private func buttonGesture(){
        addToListButton.rx.tap.subscribe(onNext: { [weak self] in
            let bottomSheetVC = AddToListBottomSheet()
            bottomSheetVC.malId = self?.malId ?? 0
            bottomSheetVC.imageUrl = self?.animeDetail?.images?.jpg?.imageUrl ?? ""
            bottomSheetVC.setContentHeight(bottomSheetVC.view.bounds.height)
            self?.presentBottomSheet(contentViewController: bottomSheetVC)
        }
        ).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        ).disposed(by: disposeBag)
        
        sourceButton.rx.tap.subscribe(onNext: {_ in
            if let urlData = self.animeDetail?.url{
                if let url = URL(string: urlData) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }).disposed(by: disposeBag)
    }
}

extension DetailAnimeViewController {
    func getFetchViewModel(){
        if let id = malId{
            AnimeViewModel.shared.getDetailAnime(malId: id){finish in
                if(finish){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        self.tableView.hideSkeleton()
                        self.addToListButton.isHidden = false
                    }
                }
            }
            AnimeViewModel.shared.getAnimeCharacter(malId: id)
            AnimeViewModel.shared.getAnimeStaff(malId: id)
            AnimeViewModel.shared.getAnimeRecommendations(malId: id)
        }
    }
    
    func bindFetchViewModel() {
        AnimeViewModel.shared.animeDetail
            .subscribe(onNext: { [weak self] i in
                
                self?.animeDetail = i
            })
            .disposed(by: disposeBag)
        AnimeViewModel.shared.animeCharacter
            .subscribe(onNext: { [weak self] i in
                
                self?.animeCharacter = i
            })
            .disposed(by: disposeBag)
        AnimeViewModel.shared.animeStaff
            .subscribe(onNext: { [weak self] i in
                
                self?.animeStaff = i
            })
            .disposed(by: disposeBag)
        AnimeViewModel.shared.animeRecommendations
            .subscribe(onNext: { [weak self] i in
                
                self?.animeRecommendation = i
            })
            .disposed(by: disposeBag)
    }
}

extension DetailAnimeViewController: SkeletonTableViewDataSource, UITableViewDelegate {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(AnimeDetailInfo.self)
        tableView.registerCellWithNib(DetailAnimeTrailer.self)
        tableView.registerCellWithNib(DetailAnimeMoreInfo.self)
        tableView.registerCellWithNib(DetailAnimeCharacter.self)
        tableView.registerCellWithNib(DetailAnimeStaff.self)
        tableView.registerCellWithNib(DetailAnimeTheme.self)
        tableView.registerCellWithNib(DetailAnimeRecommendation.self)
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 7
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0:
            return String(describing: AnimeDetailInfo.self)
        case 1:
            return String(describing: DetailAnimeTrailer.self)
        case 2:
            return String(describing: DetailAnimeMoreInfo.self)
        case 3:
            return String(describing: DetailAnimeCharacter.self)
        case 4:
            return String(describing: DetailAnimeStaff.self)
        case 5:
            return String(describing: DetailAnimeTheme.self)
        default:
            return String(describing: DetailAnimeRecommendation.self)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AnimeDetailInfo
            if let id = malId{
                cell.urlImage.hero.id = String(id)
            }
            
            if let data = animeDetail {
                cell.initialSetup(data: data)
            }
            
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeTrailer
            cell.initialYoutubeId(youtubeId: animeDetail?.trailer?.youtubeID ?? "")
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeMoreInfo
            if let data = animeDetail {
                cell.initialSetup(data: data)
            }
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeCharacter
            cell.initialSetup(data: animeCharacter)
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeStaff
            cell.initialSetup(data: animeStaff)
            cell.selectionStyle = .none
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeTheme
            if let data = animeDetail{
                cell.initialSetup(data: data)
            }
            cell.selectionStyle = .none
            return cell
        case 6:
            if(animeRecommendation.isEmpty){
                return UITableViewCell()
            }else{
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeRecommendation
                cell.initialSetup(data: animeRecommendation)
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
}

extension DetailAnimeViewController: DetailAnimeRecommendationDelegate{
    func didTapNavigation(malId: Int) {
        let vc = DetailAnimeViewController()
        vc.malId = malId
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.popViewController(animated: false)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
}
