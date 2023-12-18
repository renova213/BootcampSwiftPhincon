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
    @IBOutlet weak var updateListButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureGesture()
        tableView.showAnimatedGradientSkeleton()
        addToListButton.isHidden = true
        updateListButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        loadData()
        bindData()
    }
    
    private let detailAnimeVM = DetailAnimeViewModel()
    private let profileVM = ProfileViewModel()
    var id: String?
    var malId: Int?
    var animeDetail: AnimeDetailEntity? {
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
        configureTableView()
        addToListButton.roundCornersAll(radius: 10)
    }
    
    private func configureGesture(){
        favoriteButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            
            if let anime = self.animeDetail {
                self.detailAnimeVM.addToFavorite(for: FavoriteEnum.anime(entity: anime))
                self.favoriteButton.bounceAnimation()
            }
        }).disposed(by: disposeBag)
        
        addToListButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            let bottomSheetVC = AddToListBottomSheet()
            bottomSheetVC.malId = self.malId ?? 0
            bottomSheetVC.totalEpisode = self.animeDetail?.episodes ?? 0
            bottomSheetVC.imageUrl = self.animeDetail?.images?.jpg?.imageUrl ?? ""
            bottomSheetVC.setContentHeight(bottomSheetVC.view.bounds.height)
            self.presentBottomSheet(contentViewController: bottomSheetVC)
        }
        ).disposed(by: disposeBag)
        
        updateListButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            let bottomSheetVC = UpdateListBottomSheet()
            bottomSheetVC.malId = self.malId ?? 0
            bottomSheetVC.id = self.id
            bottomSheetVC.totalEpisode = self.animeDetail?.episodes ?? 0
            bottomSheetVC.imageUrl = self.animeDetail?.images?.jpg?.imageUrl ?? ""
            bottomSheetVC.setContentHeight(bottomSheetVC.view.bounds.height)
            self.presentBottomSheet(contentViewController: bottomSheetVC)
        }
        ).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        ).disposed(by: disposeBag)
        
        sourceButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            if let urlData = self.animeDetail?.url{
                if let url = URL(string: urlData) {
                    let vc = WebKitViewController()
                    vc.url = url
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }).disposed(by: disposeBag)
    }
}

extension DetailAnimeViewController {
    
    func loadData(){
        if let id = malId{
            detailAnimeVM.getDetailAnime(malId: id){[weak self] finish in
                guard let self = self else {return}
                
                if(finish){
                    self.tableView.hideSkeleton()
                    if let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults() {
                        UserAnimeViewModel.shared.findOneUserAnime(userId: userId, malId: id){[weak self] finish in
                            guard let self = self else {return}
                            
                            if(finish){
                                self.updateListButton.isHidden = false
                            }else{
                                self.addToListButton.isHidden = false
                            }
                        }
                    }
                }
            }
            profileVM.fetchFavoriteList(for: FetchFavoriteEnum.anime)
            profileVM.fetchFavoriteList(for: FetchFavoriteEnum.character)
            profileVM.fetchFavoriteList(for: FetchFavoriteEnum.cast)
            detailAnimeVM.getAnimeCharacter(malId: id)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.detailAnimeVM.getAnimeStaff(malId: id)
                self.detailAnimeVM.getAnimeRecommendations(malId: id)
            }
        }
    }
    
    func bindData() {
        detailAnimeVM.animeDetail
            .subscribe(onNext: { [weak self] i in
                guard let self = self, let animeDetail = i else { return }
                self.animeDetail = animeDetail
                self.detailAnimeVM.isExistFavoriteAnimeList(for: FavoriteEnum.anime(entity: animeDetail))
            })
            .disposed(by: disposeBag)
        detailAnimeVM.animeCharacter
            .subscribe(onNext: { [weak self] i in
                guard let self = self else { return }
                self.animeCharacter = i
            })
            .disposed(by: disposeBag)
        detailAnimeVM.animeStaff
            .subscribe(onNext: { [weak self] i in
                guard let self = self else { return }
                self.animeStaff = i
            })
            .disposed(by: disposeBag)
        detailAnimeVM.animeRecommendations
            .subscribe(onNext: { [weak self] i in
                guard let self = self else { return }
                self.animeRecommendation = i
            })
            .disposed(by: disposeBag)
        detailAnimeVM.isExistAnimeFavorite.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case true:
                self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            case false:
                self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }).disposed(by: disposeBag)
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
            if(animeStaff.isEmpty){
                return UITableViewCell()
            }

            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeCharacter
            cell.initialSetup(data: animeCharacter)
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case 4:
            if(animeStaff.isEmpty){
                return UITableViewCell()
            }

            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeStaff
            cell.initialSetup(data: animeStaff)
            cell.selectionStyle = .none
            cell.delegate = self
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
            }

            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeRecommendation
            cell.initialSetup(data: animeRecommendation)
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

extension DetailAnimeViewController: DetailAnimeRecommendationDelegate, detailAnimeStaffDelegate, DetailAnimeCharacterDelegate{
    
    func didTapWebKitStaff(url: URL) {
        let vc = WebKitViewController()
        vc.url = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapWebKitCharacter(url: URL) {
        let vc = WebKitViewController()
        vc.url = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapNavigation(malId: Int) {
        let vc = DetailAnimeViewController()
        vc.malId = malId
        vc.id = id
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.popViewController(animated: false)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
}
