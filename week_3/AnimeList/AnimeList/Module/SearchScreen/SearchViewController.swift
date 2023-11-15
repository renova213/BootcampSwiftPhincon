import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private var filteredAnime: [AnimeEntity] = [] { didSet { tableView.reloadData() } }
    private var filteredManga: [MangaEntity] = [] { didSet { tableView.reloadData() } }
    private var currentIndex: Int = 0 { didSet { tableView.reloadData() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(SearchCategories.self)
        tableView.registerCellWithNib(SearchResult.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
    
    private func configureSearchCategoriesCell(for indexPath: IndexPath) -> UITableViewCell {
        let searchCategories = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchCategories
        searchCategories.delegateSelectedIndex = self
        return searchCategories
    }
    
    private func configureSearchResultCell(for indexPath: IndexPath) -> UITableViewCell {
        
        return returnCell(indexPath: indexPath)
    }
    
    private func returnCell(indexPath: IndexPath) -> UITableViewCell{
        if(currentIndex == 0){
            let data = filteredAnime[indexPath.row]
            let searchResult = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchResult
            searchResult.initialSetup(urlImage: data.images?.jpg?.imageUrl ?? "",
                                      title: data.title ?? "",
                                      episode: "\(data.type ?? "") (\(data.episodes ?? 0) episode)",
                                      rating: String(data.score ?? 0.0),
                                      releaseDate: "\(data.season ?? "") \(String(data.aired?.prop?.from?.year ?? 0))")
            return searchResult
        }else{
            let data = filteredManga[indexPath.row]
            let searchResult = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchResult
            searchResult.initialSetup(urlImage: data.images?.jpg?.imageUrl ?? "",
                                      title: data.title ?? "",
                                      episode: "\(data.type ?? "") (\(data.chapters ?? 0) chapter)",
                                      rating: String(data.score ?? 0.0),
                                      releaseDate: data.status ?? "")
            return searchResult
        }
    }
}

extension SearchViewController {
    
    private func configureUI() {
        configureComponentStyle()
        backButtonGesture()
        resetViewModel()
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
    
    private func reloadData() {
        tableView.reloadData()
    }
}

extension SearchViewController {
    
    private func bindData() {
        SearchViewModel.shared.filteredAnime
            .subscribe(onNext: { [weak self] in self?.filteredAnime = $0 })
            .disposed(by: disposeBag)
        
        SearchViewModel.shared.filteredManga
            .subscribe(onNext: { [weak self] in self?.filteredManga = $0 })
            .disposed(by: disposeBag)
        
        SearchViewModel.shared.currentIndex
            .subscribe(onNext: { [weak self] in self?.currentIndex = $0 })
            .disposed(by: disposeBag)
        
        searchField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] in
                self?.getFilteredData()
            }
            .disposed(by: disposeBag)
    }
    
    private func resetViewModel() {
        SearchViewModel.shared.changeCurrentIndex(index: 0)
        filteredAnime = []
        filteredManga = []
    }
    
    private func getFilteredData() {
        if(self.currentIndex == 0){
            SearchViewModel.shared.getFilterAnime(filterParam: FilterAnimeParam(page: "1", limit: "16", q: self.searchField.text))
        }else {
            SearchViewModel.shared.getFilterManga(filterParam: FilterMangaParam(page: "1", limit: "16", q: self.searchField.text))
        }
    }
}

extension SearchViewController: SearchCategoriesDelegate {
    func selectedIndex(index: Int) {
        SearchViewModel.shared.changeCurrentIndex(index: index)
    }
}
