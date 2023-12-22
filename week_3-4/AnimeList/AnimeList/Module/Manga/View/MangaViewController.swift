import UIKit
import RxCocoa
import RxSwift
import SkeletonView
import Hero
import Toast_Swift

class MangaViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        loadData()
        bindData()
    }
    
    private let disposeBag = DisposeBag()
    private let mangaVM = MangaViewModel()
    private var style = ToastStyle()
    
    var selectedFilterIndex = 4 {
        didSet{
            tableView.reloadData()
        }
    }
    var filterString: String = "A-Z" {
        didSet{
            tableView.reloadData()
        }
    }
}

extension MangaViewController {
    
    func configureUI(){
        appBar.createAppBar()
        style.backgroundColor = UIColor(named: "Main Color") ?? UIColor.black
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(MangaListCell.self)
        tableView.registerCellWithNib(MangaSearchFilterCell.self)
    }
    
    func loadData(){
        if let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults() {
            mangaVM.loadData(for: Endpoint.getUserManga(params: userId), resultType: UserMangaResponse.self)
        }
    }
    
    func bindData(){
        
        mangaVM.loadingState.subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading, .notLoad:
                self.tableView.showAnimatedGradientSkeleton()
                break
            case .finished:
                self.tableView.hideSkeleton()
                self.tableView.reloadData()
                break
            case .failed:
                self.refreshPopUp(message: self.mangaVM.errorMessage.value)
                self.tableView.hideSkeleton()
                break
            }
        }).disposed(by: disposeBag)
        
        mangaVM.loadingState2.subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading, .notLoad:
                break
            case .finished:
                self.view.makeToast("Data deleted", duration: 2, style: self.style)
                self.loadData()
                break
            case .failed:
                self.view.makeToast(self.mangaVM.errorMessage.value, duration: 2, style: self.style)
                break
            }
        }).disposed(by: disposeBag)
    }
    
    private func refreshPopUp(message: String){
        let vc = RefreshPopUp()
        vc.delegate = self
        vc.view.alpha = 0
        vc.errorLabel.text = message
        self.present(vc, animated: false, completion: nil)
        
        UIView.animate(withDuration: 0.5) {
            vc.view.alpha = 1
        }
    }
}

extension MangaViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return mangaVM.userMangaList.value.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MangaSearchFilterCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.filterButton.setTitle(mangaVM.filterData[selectedFilterIndex], for: .normal)
            return cell
        case 1:
            let data = mangaVM.userMangaList.value[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MangaListCell
            cell.selectionStyle = .none
                cell.urlImage.hero.id = String(data.manga.malId )
            cell.initialSetup(data: data)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
//            let data = mangaVM.userMangaList.value[indexPath.row]
//            let vc = DetailAnimeViewController()
//            vc.id = data.id
//            vc.malId = data.manga.malId
//            vc.hidesBottomBarWhenPushed = true
//            navigationController?.hero.isEnabled = true
//            navigationController?.pushViewController(vc, animated: true)
//            vc.navigationController?.isNavigationBarHidden = true
        }
    }
}

extension MangaViewController: SkeletonTableViewDataSource{
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0:
            return String(describing: MangaSearchFilterCell.self)
        case 1:
            return String(describing: MangaListCell.self)
        default:
            return ""
        }
    }
}

extension MangaViewController: RefreshPopUpDelegate, MangaListCelllDelegate, MangaSearchFilterCellDelegate, FilterPopUpDelegate{
    // manga list cell
    func didTap(data: UserMangaEntity) {
        
    }
    
    func increamentEpisode(userManga: CreateUserMangaParam) {
        mangaVM.loadData(for: Endpoint.postUserManga(params: userManga), resultType: StatusResponse.self)
    }
    
    func deleteUserManga(id: String) {
        mangaVM.loadData(for: Endpoint.deleteUserManga(params: id), resultType: StatusResponse.self)
    }
    
    //refresh popup
    func didTapRefresh() {
        self.dismiss(animated: true)
        loadData()
    }
    
    //manga filter

    func didTapNavigation() {
        let vc = SearchViewController()

        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
    
    // sort
    func didTapFilterIndex(index: Int) {
        selectedFilterIndex = index
        mangaVM.sortUserManga(index: index)
    }

    func didTapFilterPopUp() {
        let vc = FilterPopUp()
        vc.delegate = self
        vc.view.alpha = 0.0
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
        UIView.animate(withDuration: 0.5) {
            vc.view.alpha = 1.0
        }
    }
}
