import UIKit

class MainTabBarViewController: UITabBarController {
    
    let dashboardVC = UINavigationController(rootViewController: DashboardViewController())
    let animeVC = UINavigationController(rootViewController: AnimeViewController())
    let mangaVC = UINavigationController(rootViewController: MangaViewController())
    let profileVC = UINavigationController(rootViewController: ProfileViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureTabBarItems()
        configureStyleTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension MainTabBarViewController{
    func configureStyleTabBar(){
        tabBar.isTranslucent = false
        tabBar.tintColor =  UIColor.white
        tabBar.backgroundColor =  UIColor(named: "Main Color")
        tabBar.unselectedItemTintColor = UIColor(named: "Second Icon Color")
    }
    
    func configureTabBarItems(){
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: SFSymbol.homeSymbol, tag: 0)
        animeVC.tabBarItem = UITabBarItem(title: "Anime", image: SFSymbol.animeSymbol, tag: 1)
        mangaVC.tabBarItem = UITabBarItem(title: "Manga", image: SFSymbol.mangaSymbol, tag: 2)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: SFSymbol.profileSymbol, tag: 3)
    }
    
    func configureTabBar(){
        setViewControllers([dashboardVC, animeVC, mangaVC, profileVC], animated: true)
    }
}
