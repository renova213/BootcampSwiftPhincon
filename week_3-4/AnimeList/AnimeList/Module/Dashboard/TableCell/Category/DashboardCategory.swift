import UIKit

protocol DashboardCategoryDelegate: AnyObject{
    func didTapNavigateRankAnime()
}

class DashboardCategory: UITableViewCell {
    @IBOutlet weak var categoryCollection: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
    }
    
    weak var delegate: DashboardCategoryDelegate?
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.didTapNavigateRankAnime()
        default:
            delegate?.didTapNavigateRankAnime()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        return CGSize(width: (screenWidth/2) - 24, height: 50)
    }
}

