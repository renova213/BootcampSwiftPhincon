import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var dashboardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView(){
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
        dashboardTableView.registerCellWithNib(DashboardSearch.self)
        dashboardTableView.registerCellWithNib(DashboardCategory.self)
        dashboardTableView.registerCellWithNib(AnimeSection.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let dashboardSearch = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardSearch
            return dashboardSearch
        case 1:
            let dashboardCategory = tableView.dequeueReusableCell(forIndexPath: indexPath) as DashboardCategory
            return dashboardCategory
        case 2:
            let animeSection = tableView.dequeueReusableCell(forIndexPath: indexPath) as AnimeSection
            return animeSection
        default:
            return UITableViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y

        let threshold: CGFloat = 100

        if yOffset > threshold {
            tabBarController?.tabBar.alpha = 0
        } else {
            tabBarController?.tabBar.alpha = 1
        }
    }
}
