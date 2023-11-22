import UIKit
import RxSwift

protocol SearchCategoriesDelegate: AnyObject{
    func selectedIndex(index: Int)
}

class SearchCategories: UITableViewCell {
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
        bindViewModel()
    }
    let disposeBag = DisposeBag()
    var currentIndex: Int = 0{
        didSet{
            searchCollectionView.reloadData()
        }
    }
    weak var delegateSelectedIndex: SearchCategoriesDelegate?
}

extension SearchCategories: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func configureCollectionView(){
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.registerCellWithNib(SelectedSearchCategoryItem.self)
        searchCollectionView.registerCellWithNib(UnselectedSearchCategoryItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SearchViewModel.shared.searchCategoryItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = SearchViewModel.shared.searchCategoryItem[indexPath.row]
        
        switch currentIndex == indexPath.row{
        case true:
            let selectedCategoryItem = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedSearchCategoryItem", for: indexPath) as! SelectedSearchCategoryItem
            selectedCategoryItem.searchCategoryButton.setTitle(data, for: .normal)
            return selectedCategoryItem
        case false:
            let unselectedCategoryItem = collectionView.dequeueReusableCell(withReuseIdentifier: "UnselectedSearchCategoryItem", for: indexPath) as! UnselectedSearchCategoryItem
            unselectedCategoryItem.searchCategoryButton.setTitle(data, for: .normal)
            return unselectedCategoryItem
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateSelectedIndex?.selectedIndex(index: indexPath.row)
    }
}

extension SearchCategories{
    func bindViewModel (){
        SearchViewModel.shared.currentIndex.subscribe(onNext: { self.currentIndex = $0 }).disposed(by: disposeBag)
    }
}
