//
//  MainTabBarViewController.swift
//  AnimeList
//
//  Created by Phincon on 10/11/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    let dashboardVC = UINavigationController(rootViewController: DashboardViewController())
    let animeVC = UINavigationController(rootViewController: AnimeViewController())
    let mangaVC = UINavigationController(rootViewController: MangaViewController())
    let otherVC = UINavigationController(rootViewController: OtherViewController())
    
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
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

extension MainTabBarViewController{
    func configureStyleTabBar(){
        self.tabBar.tintColor =  UIColor(named: "Main Color")
        self.tabBar.unselectedItemTintColor = UIColor(named: "Second Icon Color")
    }
    
    func configureTabBarItems(){
        dashboardVC.tabBarItem = UITabBarItem(title: "Dashboard", image: SFSymbol.homeSymbol, tag: 0)
        animeVC.tabBarItem = UITabBarItem(title: "Anime", image: SFSymbol.animeSymbol, tag: 1)
        mangaVC.tabBarItem = UITabBarItem(title: "Manga", image: SFSymbol.mangaSymbol, tag: 2)
        otherVC.tabBarItem = UITabBarItem(title: "Lain", image: SFSymbol.otherSymbol, tag: 3)
    }
    
    func configureTabBar(){
        setViewControllers([dashboardVC, animeVC, mangaVC, otherVC], animated: true)
    }
}
