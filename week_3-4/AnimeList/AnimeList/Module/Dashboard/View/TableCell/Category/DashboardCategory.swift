import UIKit

class DashboardCategory: UITableViewCell {
    @IBOutlet weak var categoryCollection: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
    }
    
    weak var delegate: DashboardCategoryItemDelegate?
}

extension DashboardCategory: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func configureTableView(){
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        categoryCollection.registerCellWithNib(DashboardCategoryItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DashboardCategoryEntity.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryItem = DashboardCategoryEntity.items[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCategoryItem", for: indexPath) as! DashboardCategoryItem
        
        cell.setUpButton(title: categoryItem.title, icon: categoryItem.icon.withTintColor(UIColor.white))
        cell.delegate = self
        cell.index = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        return CGSize(width: (screenWidth/2) - 24, height: 50)
    }
}

extension DashboardCategory: DashboardCategoryItemDelegate{
    func didTapNavigateRankAnime(index: Int) {
        delegate?.didTapNavigateRankAnime(index: index)
    }
}

