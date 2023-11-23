import UIKit
import RxCocoa
import RxSwift
import SkeletonView
import Hero

class AnimeViewController: UIViewController {
    @IBOutlet weak var filterWatchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        tableView.showAnimatedGradientSkeleton()
        filterWatchButton.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.filterWatchButton.isHidden = false
            self.tableView.hideSkeleton()
        }
    }
    
    func configureUI(){
        filterWatchButton.roundCornersAll(radius: 10)
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(AnimeListCell.self)
        tableView.registerCellWithNib(AnimeSearchFilterCell.self)
    }
}

extension AnimeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 9
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AnimeSearchFilterCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AnimeListCell
            cell.selectionStyle = .none
            cell.urlImage.hero.id = "48316"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
            let vc = DetailAnimeViewController()
            vc.malId = 48316
            vc.hidesBottomBarWhenPushed = true
            navigationController?.hero.isEnabled = true
            navigationController?.pushViewController(vc, animated: true)
            vc.navigationController?.isNavigationBarHidden = true
        }
    }
}

extension AnimeViewController: SkeletonTableViewDataSource{
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 9
        default:
            return 0
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0:
            return String(describing: AnimeSearchFilterCell.self)
        case 1:
            return String(describing: AnimeListCell.self)
        default:
            return ""
        }
    }
}

extension AnimeViewController: AnimeSearchFilterCellDelegate{
    func didTapNavigation() {
        let vc = SearchViewController()
        
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationController?.isNavigationBarHidden = true
    }
}
