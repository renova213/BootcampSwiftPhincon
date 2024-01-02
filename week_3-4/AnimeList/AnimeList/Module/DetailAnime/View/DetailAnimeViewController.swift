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
    
    var id: String?
    var malId: Int?
    
    private let disposeBag = DisposeBag()
    
    private func configureUI() {
        configureTableView()
        addToListButton.roundCornersAll(radius: 10)
    }
    
    private func configureGesture(){
        favoriteButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            
            if let anime = DetailAnimeViewModel.shared.animeDetail.value {
                FavoriteViewModel.shared.addToFavorite(for: FavoriteEnum.anime(entity: anime))
                self.favoriteButton.bounceAnimation()
            }
        }).disposed(by: disposeBag)
        
        addToListButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            let bottomSheetVC = AddToListBottomSheet()
            bottomSheetVC.malId = self.malId ?? 0
            bottomSheetVC.totalEpisode = DetailAnimeViewModel.shared.animeDetail.value?.episodes ?? 0
            bottomSheetVC.imageUrl = DetailAnimeViewModel.shared.animeDetail.value?.images?.jpg?.imageUrl ?? ""
            bottomSheetVC.setContentHeight(bottomSheetVC.view.bounds.height)
            self.presentBottomSheet(contentViewController: bottomSheetVC)
        }
        ).disposed(by: disposeBag)
        
        updateListButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            let bottomSheetVC = UpdateListBottomSheet()
            bottomSheetVC.malId = self.malId ?? 0
            bottomSheetVC.id = self.id
            bottomSheetVC.totalEpisode = DetailAnimeViewModel.shared.animeDetail.value?.episodes ?? 0
            bottomSheetVC.imageUrl = DetailAnimeViewModel.shared.animeDetail.value?.images?.jpg?.imageUrl ?? ""
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
            if let urlData = DetailAnimeViewModel.shared.animeDetail.value?.url{
                if let url = URL(string: urlData) {
                    let vc = WebKitViewController()
                    vc.url = url
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func loadData(){
        DispatchQueue.main.async {
            if let id = self.malId{
                DetailAnimeViewModel.shared.loadData(for: Endpoint.getDetailAnime(params: id), resultType: AnimeDetailResponse.self)
                
                ProfileViewModel.shared.fetchFavoriteList(for: FetchFavoriteEnum.anime)
                ProfileViewModel.shared.fetchFavoriteList(for: FetchFavoriteEnum.animeCharacter)
                ProfileViewModel.shared.fetchFavoriteList(for: FetchFavoriteEnum.animeCast)
                DetailAnimeViewModel.shared.loadData(for: Endpoint.getAnimeCharacter(params: id), resultType: AnimeCharacterResponse.self)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    DetailAnimeViewModel.shared.loadData(for: Endpoint.getAnimeStaff(params: id), resultType: AnimeStaffResponse.self)
                    DetailAnimeViewModel.shared.loadData(for: Endpoint.getRecommendationAnime(params: id), resultType: AnimeRecommendationResponse.self)
                }
                
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
                
                if let animeDetail = DetailAnimeViewModel.shared.animeDetail.value {
                    FavoriteViewModel.shared.isExistFavoriteList(for: FavoriteEnum.anime(entity: animeDetail))
                }
            }
        }
    }
    
    func bindData() {
        DetailAnimeViewModel.shared.loadingState
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .initial, .empty:
                    break
                case .loading:
                    self.tableView.showAnimatedGradientSkeleton()
                    break
                case .finished:
                    self.tableView.reloadData()
                    self.tableView.hideSkeleton()
                    break
                case .failed:
                    self.refreshPopUp(message: DetailAnimeViewModel.shared.errorMessage.value)
                    break
                }
            })
            .disposed(by: disposeBag)
        
        FavoriteViewModel.shared.isExistAnimeFavorite.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case true:
                self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            case false:
                self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }).disposed(by: disposeBag)
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
            return String(describing: UITableViewCell().self)
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
            
            if let data = DetailAnimeViewModel.shared.animeDetail.value {
                cell.initialSetup(data: data)
            }
            
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeTrailer
            cell.initialYoutubeId(youtubeId: DetailAnimeViewModel.shared.animeDetail.value?.trailer?.youtubeID ?? "")
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeMoreInfo
            if let data = DetailAnimeViewModel.shared.animeDetail.value {
                cell.initialSetup(data: data)
            }
            cell.selectionStyle = .none
            return cell
        case 3:
            if(DetailAnimeViewModel.shared.animeCharacter.value.isEmpty){
                return UITableViewCell()
            }else{
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeCharacter
                cell.initialSetup(data: DetailAnimeViewModel.shared.animeCharacter.value)
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            }
            
        case 4:
            if(DetailAnimeViewModel.shared.animeStaff.value.isEmpty){
                return UITableViewCell()
            }else{
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeStaff
                cell.initialSetup(data: DetailAnimeViewModel.shared.animeStaff.value)
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            }
            
        case 5:
            if(DetailAnimeViewModel.shared.animeDetail.value == nil){
                return UITableViewCell()
            }else{
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeTheme
                if let data = DetailAnimeViewModel.shared.animeDetail.value{
                    cell.initialSetup(data: data)
                }
                cell.selectionStyle = .none
                return cell
            }
            
        case 6:
            if(DetailAnimeViewModel.shared.animeRecommendations.value.isEmpty){
                return UITableViewCell()
            }else{
                
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as DetailAnimeRecommendation
                cell.initialSetup(data: DetailAnimeViewModel.shared.animeRecommendations.value)
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
}

extension DetailAnimeViewController: DetailAnimeRecommendationDelegate, detailAnimeStaffDelegate, DetailAnimeCharacterDelegate, RefreshPopUpDelegate{
    // refresh pop up
    func didTapRefresh() {
        loadData()
    }
    
    // detail anime staff
    func didTapWebKitStaff(url: URL) {
        let vc = WebKitViewController()
        vc.url = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // detail anime character
    func didTapWebKitCharacter(url: URL) {
        let vc = WebKitViewController()
        vc.url = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // detail anime recommendation
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
