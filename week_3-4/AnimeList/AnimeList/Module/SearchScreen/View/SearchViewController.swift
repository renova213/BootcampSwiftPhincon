import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindData()
    }
    
    let disposeBag = DisposeBag()
    var filteredAnime: [AnimeEntity] = [] { didSet { tableView.reloadData() } }
    var filteredManga: [MangaEntity] = [] { didSet { tableView.reloadData() } }
    var currentIndex: Int = 0 { didSet { tableView.reloadData() } }
    private lazy var searchVM = SearchViewModel()
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource,SkeletonTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if(currentIndex == 0){
                return filteredAnime.count
            }else{
                return filteredManga.count
            }
        default:
            return 0
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0:
            return String(describing: SearchCategories.self)
        default:
            return String(describing: SearchResultCell.self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return configureSearchCategoriesCell(for: indexPath)
        case 1:
            return configureSearchResultCell(for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(currentIndex == 0 && indexPath.section == 1){
            let data = filteredAnime[indexPath.row]
            let vc = DetailAnimeViewController()
            vc.malId = data.malId
            navigationController?.hero.isEnabled = true
            navigationController?.pushViewController(vc, animated: true)
        }
        
       if(currentIndex == 1 && indexPath.section == 1){
           let data = filteredManga[indexPath.row]
           let vc = DetailMangaViewController()
           vc.malId = data.malId
           navigationController?.hero.isEnabled = true
           navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func configureSearchCategoriesCell(for indexPath: IndexPath) -> UITableViewCell {
        let searchCategories = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchCategories
        searchCategories.selectionStyle = .none
        searchCategories.delegate = self
        return searchCategories
    }
    
    private func configureSearchResultCell(for indexPath: IndexPath) -> UITableViewCell {
        
        return returnCell(indexPath: indexPath)
    }
    
    private func returnCell(indexPath: IndexPath) -> UITableViewCell{
        if(currentIndex == 0){
            let data = filteredAnime[indexPath.row]
            let searchResult = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchResultCell
            searchResult.initialSetupAnime(data: data)
            searchResult.selectionStyle = .none
            
            return searchResult
        }else{
            let data = filteredManga[indexPath.row]
            let searchResult = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchResultCell
            searchResult.initialSetupManga(data: data)
            searchResult.selectionStyle = .none
            
            return searchResult
        }
    }
}

extension SearchViewController {
    
    private func configureUI() {
        configureComponentStyle()
        backButtonGesture()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(SearchCategories.self)
        tableView.registerCellWithNib(SearchResultCell.self)
    }
    
    private func backButtonGesture() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureComponentStyle() {
        searchField.borderStyle = .none
    }
}

extension SearchViewController {
    
    private func bindData() {
        searchVM.filteredAnime.asObservable()
            .subscribe(onNext: { [weak self] in self?.filteredAnime = $0 })
            .disposed(by: disposeBag)
        
        searchVM.filteredManga.asObservable()
            .subscribe(onNext: { [weak self] in self?.filteredManga = $0 })
            .disposed(by: disposeBag)
        
        searchVM.currentIndex.asObservable()
            .subscribe(onNext: { [weak self] in self?.currentIndex = $0 })
            .disposed(by: disposeBag)
        
        searchField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] in
                self?.loadData()
            }
            .disposed(by: disposeBag)
        
        searchVM.loadingState.asObservable()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .notLoad, .loading:
                    self.tableView.showAnimatedGradientSkeleton()
                case  .finished, .failed:
                    self.tableView.hideSkeleton()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func loadData() {
        if(self.currentIndex == 0){
            searchVM.filteredAnime.accept([])
            searchVM.loadData(for: Endpoint.filterAnime(params:FilterAnimeParam(page: "1", limit: "16", q: self.searchField.text)), resultType: AnimeResponse.self)
        }else {
            searchVM.filteredManga.accept([])
            searchVM.loadData(for: Endpoint.filterManga(params:FilterMangaParam(page: "1", limit: "16", q: self.searchField.text)), resultType: MangaResponse.self)
        }
    }
}

extension SearchViewController: SearchCategoriesDelegate {
    func selectedIndex(index: Int) {
        searchVM.changeCurrentIndex(index: index)
        loadData()
    }
}
