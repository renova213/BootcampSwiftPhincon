import UIKit
import RxSwift
import RxCocoa
import FloatingPanel
import SkeletonView
import Toast_Swift
import Hero
import Lottie

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appBar: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        bindData()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private var profileStatsTabState = false {
        didSet{
            tableView.reloadData()
        }
    }
    
    private var style = ToastStyle()
    let pickerImage = UIImagePickerController()
    private let profileVM = ProfileViewModel()
    private var userData: UserEntity?
    private var favoriteAnimeList: [FavoriteAnimeEntity] = []
    private var favoriteAnimeCharacterList: [FavoriteAnimeCharacterEntity] = []
    private var favoriteAnimeCastList: [FavoriteAnimeCastEntity] = []
    private var favoriteMangaList: [FavoriteMangaEntity] = []
    private var userRecentUpdates: [UserRecentUpdateEntity] = []
    private var userStats: UserStatsEntity?
    
    private var toggleMinimizeFavorite: Bool = false {
        didSet{
            tableView.reloadData()
        }
    }
    
    private var toggleMinimizeRecentUpdate: Bool = false {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        emptyStateAnimationView.removeFromSuperview()
    }
    
    private lazy var emptyStateAnimationView = LottieAnimationView(name: "empty")
    
    private let disposeBag = DisposeBag()
}

extension ProfileViewController {
    func bindData(){
        profileVM.toggle.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            self.profileStatsTabState = state
        }).disposed(by: DisposeBag())
        
        profileVM.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case .initial:
                break
            case .empty:
                break
            case .loading, .failed:
                self.tableView.showAnimatedGradientSkeleton()
                break
            case .finished:
                self.tableView.reloadData()
                self.tableView.hideSkeleton()
            }
        }).disposed(by: disposeBag)
        
        profileVM.userData.asObservable().subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            if let responseData = data {
                self.userData = responseData
            }
        }).disposed(by: disposeBag)
        
        profileVM.favoriteAnimeList.asObservable().subscribe(onNext: {[weak self] animeFavorite in
            guard let self = self else { return }
            self.favoriteAnimeList = animeFavorite
        }).disposed(by: disposeBag)
        
        profileVM.favoriteAnimeCharacterList.asObservable().subscribe(onNext: {[weak self] animeCharacter in
            guard let self = self else { return }
            self.favoriteAnimeCharacterList = animeCharacter
        }).disposed(by: disposeBag)
        
        profileVM.favoriteAnimeCastList.asObservable().subscribe(onNext: {[weak self] animeCast in
            guard let self = self else { return }
            self.favoriteAnimeCastList = animeCast
        }).disposed(by: disposeBag)
        
        profileVM.favoriteMangaList.asObservable().subscribe(onNext: {[weak self] mangaFavorite in
            guard let self = self else { return }
            self.favoriteMangaList = mangaFavorite
        }).disposed(by: disposeBag)
        
        profileVM.userRecentUpdates.asObservable().subscribe(onNext: {[weak self] userUpdates in
            guard let self = self else { return }
            self.userRecentUpdates = userUpdates
        }).disposed(by: disposeBag)
        
        profileVM.userStats.asObservable().subscribe(onNext: {[weak self] userStats in
            guard let self = self else { return }
            self.userStats = userStats
        }).disposed(by: disposeBag)
    }
    
    func loadData(){
        if let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults(){
            profileVM.loadData(for: Endpoint.getUser(params: userId), resultType: UserResponse.self)
            profileVM.loadData(for: Endpoint.getUserRecentUpdate(params: userId), resultType: UserRecentUpdateResponse.self)
            profileVM.loadData(for: Endpoint.getUserStats(params: UserStatsParam(userId: userId)), resultType: UserStatsResponse.self)
        }
        profileVM.fetchFavoriteList(for: FetchFavoriteEnum.manga)
        profileVM.fetchFavoriteList(for: FetchFavoriteEnum.animeCast)
        profileVM.fetchFavoriteList(for: FetchFavoriteEnum.anime)
        profileVM.fetchFavoriteList(for: FetchFavoriteEnum.animeCharacter)
    }
    
    func configureUI(){
        appBar.createAppBar()
        style.backgroundColor = UIColor(named: "Main Color") ?? UIColor.black
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(ProfileInfoCell.self)
        tableView.registerCellWithNib(ProfileStatsCell.self)
        tableView.registerCellWithNib(ProfileFavoriteCell.self)
        tableView.registerCellWithNib(ProfileRecentUpdate.self)
    }
    
    func presentPicker(sourceType: UIImagePickerController.SourceType) {
        pickerImage.allowsEditing = true
        pickerImage.delegate = self
        pickerImage.sourceType = sourceType
        present(pickerImage, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let cellTypes: [String] = [String(describing: ProfileInfoCell.self), String(describing: ProfileStatsCell.self), String(describing: ProfileRecentUpdate.self), String(describing: ProfileFavoriteCell.self)]
        return cellTypes[indexPath.section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileInfoCell
            if let userData = self.userData {
                cell.initialSetup(data: userData)
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileStatsCell
            cell.selectionStyle = .none
            cell.delegate = self
            if let userStats = userStats {
                cell.initialSetup(tabBarState: profileStatsTabState, userStats: userStats)
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileRecentUpdate
            cell.userRecentUpdates = userRecentUpdates
            
            if(userRecentUpdates.count < 3){
                cell.heightTableView.constant = CGFloat(userRecentUpdates.count * 112)
                cell.viewAllUpdate.isHidden = true
            }else{
                cell.heightTableView.constant = 240
                cell.viewAllUpdate.isHidden = false
            }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileFavoriteCell
            cell.selectionStyle = .none
            
            cell.initialChevronButton(state: toggleMinimizeFavorite)
            
            if(self.favoriteAnimeList.isEmpty){
                cell.animeCollection.showEmptyStateAnimation(animationView: emptyStateAnimationView)
            }else{
                cell.animeCollection.hideEmptyStateAnimation(animationView: emptyStateAnimationView)
            }
            
            if(self.favoriteAnimeCharacterList.isEmpty){
                cell.characterCollection.showEmptyStateAnimation(animationView: emptyStateAnimationView)
            }else{
                cell.characterCollection.hideEmptyStateAnimation(animationView: emptyStateAnimationView)
            }
            
            if(self.favoriteAnimeCastList.isEmpty){
                cell.castCollection.showEmptyStateAnimation(animationView: emptyStateAnimationView)
            }else{
                cell.castCollection.hideEmptyStateAnimation(animationView: emptyStateAnimationView)
            }
            
            if(self.favoriteMangaList.isEmpty){
                cell.mangaCollection.showEmptyStateAnimation(animationView: emptyStateAnimationView)
            }else{
                cell.mangaCollection.hideEmptyStateAnimation(animationView: emptyStateAnimationView)
            }
            
            cell.favoriteAnimeList = self.favoriteAnimeList
            cell.favoriteAnimeCharacter = self.favoriteAnimeCharacterList
            cell.favoriteAnimeCast = self.favoriteAnimeCastList
            cell.favoriteManga = self.favoriteMangaList
            
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension ProfileViewController: FloatingPanelControllerDelegate{
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return ProfileFloatingPanel()
    }
    
    func presentFloatingPanel(){
        let fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.isRemovalInteractionEnabled = true
        fpc.surfaceView.appearance.cornerRadius = 20
        let contentVC = ProfileSettingViewController()
        contentVC.delegate = self
        contentVC.hidesBottomBarWhenPushed = true
        contentVC.navigationController?.isNavigationBarHidden = true
        fpc.set(contentViewController: contentVC)
        self.present(fpc, animated: true, completion: nil)
    }
}

extension ProfileViewController: ProfileStatsCellDelegate, ProfileFavoriteCellDegelate, ProfileInfoCellDelegate, ProfileSettingViewControllerDelegate, UpdateProfileViewControllerDelegate, ProfileRecentUpdateDelegate {
    
    //UpdateProfileViewControllerDelegate
    func didLoadUserData() {
        loadData()
    }
    
    //ProfileSettingViewControllerDelegate
    func didTapChangePassword() {
        let vc = ChangePasswordViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    func didTapSignOut() {
        UserDefaultHelper.shared.deleteUserIDFromUserDefaults()
        TokenHelper.shared.deleteToken()
        let vc = AuthViewController()
        self.view.makeToast("Signout success", duration: 2, style: self.style)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let appDelegate = windowScene.delegate as? SceneDelegate {
                let navigationController = UINavigationController(rootViewController: vc)
                appDelegate.window?.rootViewController = navigationController
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    func didTapUpdateProfile() {
        let vc = UpdateProfileViewController()
        vc.view.alpha = 0.0
        
        if let user = self.userData {
            vc.birthdayField.text = user.birthday
            vc.emailField.text = user.email
            vc.usernameField.text = user.username
        }
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
        UIView.animate(withDuration: 0.5) {
            vc.view.alpha = 1.0
        }
    }
    
    //ProfileRecentUpdateDelegate
    func didNavigationMoreRecentUpdate() {
        let vc = MoreRecentUpdateViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
    
    //ProfileInfoCellDelegate
    func didTapGalleryImage() {
        presentPicker(sourceType: .photoLibrary)
    }
    func didTapNavigationSetting() {
        self.presentFloatingPanel()
    }
    
    //ProfileStatsCellDelegate
    func didTapTab(state: Bool) {
        profileStatsTabState = state
    }
    
    //profileFavoriteDelegate
    func didNavigateDetailAnime(malId: Int) {
        let vc = DetailAnimeViewController()
        vc.malId = malId
        navigationController?.hero.isEnabled = true
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
    func didNavigateDetailManga(malId: Int) {
        let vc = DetailMangaViewController()
        vc.malId = malId
        navigationController?.hero.isEnabled = true
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
    func minimizeFavorite() {
        toggleMinimizeFavorite = !toggleMinimizeFavorite
    }
    func didTapFavoriteItem(url: String) {
        guard let url = URL(string: url) else {return}
        
        let vc = WebKitViewController()
        vc.url = url
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        if let imageData = image.jpegData(compressionQuality: 0.5), let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults(){
            profileVM.multipartData(for: Endpoint.postUploadProfileImage(params: UploadProfileImageParam(userId: userId)),image: imageData, resultType: StatusResponse.self)
        }
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
