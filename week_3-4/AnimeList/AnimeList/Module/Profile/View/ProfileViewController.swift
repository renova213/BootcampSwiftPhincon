import UIKit
import RxSwift
import RxCocoa
import FloatingPanel
import SkeletonView
import Toast_Swift

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appBar: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindData()
        loadData()
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    var profileStatsTabState = false {
        didSet{
            tableView.reloadData()
        }
    }
    
    private var style = ToastStyle()
    let pickerImage = UIImagePickerController()
    private let profileVM = ProfileViewModel()
    
    var userData: UserEntity? {
        didSet{
            tableView.reloadData()
        }
    }
    
    var favoriteAnimeList: [FavoriteAnimeEntity] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    var favoriteAnimeCharacterList: [FavoriteAnimeCharacterEntity] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    var favoriteAnimeCastList: [FavoriteAnimeCastEntity] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    var userRecentUpdates: [UserRecentUpdateEntity] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
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
            case .loading, .failed:
                self.tableView.showAnimatedGradientSkeleton()
                break
            case .finished, .notLoad:
                self.tableView.hideSkeleton()
            }
        }).disposed(by: disposeBag)
        
        profileVM.userData.asObservable().subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            if let responseData = data {
                self.userData = responseData
                self.tableView.reloadData()
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
        
        profileVM.favoriteAnimeCastList.asObservable().subscribe(onNext: {[weak self] animeCharacter in
            guard let self = self else { return }
            self.favoriteAnimeCastList = animeCharacter
        }).disposed(by: disposeBag)
        
        profileVM.userRecentUpdates.asObservable().subscribe(onNext: {[weak self] userUpdates in
            guard let self = self else { return }
            self.userRecentUpdates = userUpdates
        }).disposed(by: disposeBag)
    }
    
    func loadData(){
        if let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults(){
            profileVM.loadData(for: Endpoint.getUser(params: userId), resultType: UserResponse.self)
            profileVM.loadData(for: Endpoint.getUserRecentUpdate(params: userId), resultType: UserRecentUpdateResponse.self)
        }
        profileVM.fetchFavoriteList(for: FetchFavoriteEnum.anime)
        profileVM.fetchFavoriteList(for: FetchFavoriteEnum.character)
        profileVM.fetchFavoriteList(for: FetchFavoriteEnum.cast)
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
            cell.initialSetup(tabBarState: profileStatsTabState)
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
            
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileFavoriteCell
            cell.selectionStyle = .none
            cell.initialChevronButton(state: toggleMinimizeFavorite)
            cell.favoriteAnimeList = self.favoriteAnimeList
            cell.favoriteAnimeCharacter = self.favoriteAnimeCharacterList
            cell.favoriteAnimeCast = self.favoriteAnimeCastList
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

extension ProfileViewController: ProfileStatsCellDelegate, ProfileFavoriteCellDegelate, ProfileInfoCellDelegate, ProfileSettingViewControllerDelegate, UpdateProfileViewControllerDelegate {
    func didLoadUserData() {
        loadData()
    }
    
    func didTapGalleryImage() {
        presentPicker(sourceType: .photoLibrary)
    }
 
    func minimizeFavorite() {
        toggleMinimizeFavorite = !toggleMinimizeFavorite
    }
    
    func didTapTab(state: Bool) {
        profileStatsTabState = state
    }
    
    func didTapNavigationSetting() {
        self.presentFloatingPanel()
    }
    
    func didTapSignOut() {
        UserDefaultHelper.shared.deleteUserIDFromUserDefaults()
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
    
    func didTapChangePassword() {
        let vc = ChangePasswordViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
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
