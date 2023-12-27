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
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    private let disposeBag = DisposeBag()
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
            MangaViewModel.shared.loadData(for: Endpoint.getUserManga(params: userId), resultType: UserMangaResponse.self)
        }
    }
    
    func bindData(){
        MangaViewModel.shared.reloadDataRelay.subscribe(onNext: {[weak self] userManga in
            guard let self = self else { return }
            MangaViewModel.shared.userMangaList.accept(userManga)
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        MangaViewModel.shared.loadingState.subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                self.tableView.showAnimatedGradientSkeleton()
                break
            case .initial:
                break
            case .finished:
                self.tableView.hideSkeleton()
                self.tableView.reloadData()
                break
            case .failed:
                self.refreshPopUp(message: MangaViewModel.shared.errorMessage.value)
                self.tableView.hideSkeleton()
                break
            }
        }).disposed(by: disposeBag)
        
        MangaViewModel.shared.loadingState2.subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                break
            case .initial:
                break
            case .finished:
                self.tableView.reloadData()
                break
            case .failed:
                self.view.makeToast(MangaViewModel.shared.errorMessage.value, duration: 2, style: self.style)
                break
            }
        }).disposed(by: disposeBag)
        
        MangaViewModel.shared.showUpdateMangaListBottomSheetRelay.subscribe(onNext: {[weak self] userManga in
            guard let self = self else { return }
            let bottomSheetVC = UpdateMangaListBottomSheet()
            bottomSheetVC.setContentHeight(bottomSheetVC.view.bounds.height)
            bottomSheetVC.initialData(userManga: userManga)
            bottomSheetVC.userManga = userManga
            self.presentBottomSheet(contentViewController: bottomSheetVC)
        }).disposed(by: disposeBag)
        
        MangaViewModel.shared.currentFilterIndex.subscribe(onNext: {[weak self] index in
            guard let self = self else { return }
            self.selectedFilterIndex = index
        }).disposed(by: disposeBag)
        
        MangaViewModel.shared.increamentMangaChapterRelay.subscribe(onNext: { updateUserMangaParam in
            MangaViewModel.shared.loadData(for: Endpoint.putUserManga(params: updateUserMangaParam), resultType: UserMangaResponse.self)
        }).disposed(by: disposeBag)
        
        MangaViewModel.shared.deleteUserMAngaRelay.subscribe(onNext: { id in
            MangaViewModel.shared.loadData(for: Endpoint.deleteUserManga(params: id), resultType: UserMangaResponse.self)
        }).disposed(by: disposeBag)
        
        MangaViewModel.shared.showFilterPopUpRelay.subscribe(onNext: { id in
            let vc = FilterPopUp()
            vc.delegate = self
            vc.view.alpha = 0.0
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false, completion: nil)
            UIView.animate(withDuration: 0.5) {
                vc.view.alpha = 1.0
            }
        }).disposed(by: disposeBag)
        
        MangaViewModel.shared.navigateSearchViewRelay.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            let vc = SearchViewController()
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationController?.isNavigationBarHidden = true
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
            return MangaViewModel.shared.userMangaList.value.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MangaSearchFilterCell
            cell.selectionStyle = .none
            cell.filterButton.setTitle(MangaViewModel.shared.filterData[selectedFilterIndex], for: .normal)
            return cell
        case 1:
            let data = MangaViewModel.shared.userMangaList.value[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MangaListCell
            cell.selectionStyle = .none
            cell.urlImage.hero.id = String(data.manga.malId)
            cell.initialSetup(data: data)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
            let data = MangaViewModel.shared.userMangaList.value[indexPath.row]
            let vc = DetailMangaViewController()
            vc.malId = data.manga.malId
            vc.hidesBottomBarWhenPushed = true
            navigationController?.hero.isEnabled = true
            navigationController?.pushViewController(vc, animated: true)
            vc.navigationController?.isNavigationBarHidden = true
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

extension MangaViewController: RefreshPopUpDelegate, FilterPopUpDelegate{
    //refresh popup
    func didTapRefresh() {
        self.dismiss(animated: true)
        loadData()
    }
    
    // sort
    func didTapFilterIndex(index: Int) {
        selectedFilterIndex = index
        MangaViewModel.shared.sortUserManga(index: index)
    }
}
