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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        
        switch currentIndex == indexPath.row{
        case true:
            let selectedCategoryItem = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedSearchCategoryItem", for: indexPath) as! SelectedSearchCategoryItem
            return selectedCategoryItem
        case false:
            let unselectedCategoryItem = collectionView.dequeueReusableCell(withReuseIdentifier: "UnselectedSearchCategoryItem", for: indexPath) as! UnselectedSearchCategoryItem
            return unselectedCategoryItem
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateSelectedIndex?.selectedIndex(index: indexPath.row)
    }
}

extension SearchCategories{
    func bindViewModel (){
        AnimeViewModel.shared.currentIndex.subscribe(onNext: { self.currentIndex = $0 }).disposed(by: disposeBag)
    }
}
