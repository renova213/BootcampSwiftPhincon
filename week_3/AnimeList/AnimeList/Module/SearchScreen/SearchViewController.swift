import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    weak var delegate: SearchCategoriesDelegate?
    var filteredAnime: [AnimeEntity] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var currentIndex:Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        currentIndex = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindFetchViewModel()
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
            return filteredAnime.count
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
        let data = filteredAnime[indexPath.row]
        let searchResult = tableView.dequeueReusableCell(forIndexPath: indexPath) as SearchResult
        searchResult.initialSetup(urlImage: data.images?.jpg?.imageUrl ?? "",
                                  title: data.title ?? "",
                                  episode: "\(data.type ?? "") (\(data.episodes ?? 0) episodes)",
                                  rating: String(data.score ?? 0),
                                  releaseDate: "\(data.season ?? "-") \(String(data.aired?.prop?.from?.year ?? 0))")
        return searchResult
    }
}

extension SearchViewController {
    
    private func configureUI() {
        configureComponentStyle()
        backButtonGesture()
        textFieldEvent()
    }
    
    private func backButtonGesture() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func textFieldEvent() {
        searchField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] in
                self?.getFilteredAnime(filterParam: FilterAnimeParam(page: "1", limit: "20", q: self?.searchField.text))
                self?.searchField.text = ""
            }
            .disposed(by: disposeBag)
    }
    
    private func configureComponentStyle() {
        searchField.borderStyle = .none
    }
    
    private func getFilteredAnime(filterParam: FilterAnimeParam) {
        AnimeViewModel.shared.getFilterAnime(filterParam: filterParam)
    }
    
    private func bindFetchViewModel() {
        AnimeViewModel.shared.filterAnime
            .subscribe(onNext: { self.filteredAnime = $0 }).disposed(by: disposeBag)
        
        AnimeViewModel.shared.currentIndex.subscribe(onNext: { self.currentIndex = $0 }).disposed(by: disposeBag)
    }
}

extension SearchViewController: SearchCategoriesDelegate {
    func selectedIndex(index: Int) {
        AnimeViewModel.shared.changeCurrentIndex(index: index)
    }
}
