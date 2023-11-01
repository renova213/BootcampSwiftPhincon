//
//  MainTabBarViewController.swift
//  latihan_hari_1
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    let homeVC = UINavigationController(rootViewController: DashboardViewController())
//    let walletViewController = UINavigationController(rootViewController: WalletViewController())
    let historyViewController = UINavigationController(rootViewController: HistoryViewController())
    let profileViewController = UINavigationController(rootViewController: ProfileViewController())

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        configureTabBar()
        configureTabBarItems()
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.tintColor = UIColor(named: "Icon Color")
        self.tabBar.unselectedItemTintColor = UIColor(named: "SecondIconColor")
    }
    
    
    func configureTabBarItems(){
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: SFSymbol.homeSymbol, tag: 0)
//        historyViewController.tabBarItem = UITabBarItem(title: "Wallet", image: SFSymbol.walletSymbol, tag: 1)
        historyViewController.tabBarItem = UITabBarItem(title: "History", image: SFSymbol.historySymbol, tag: 1)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: SFSymbol.profileSymbol, tag: 2)
    }

    func configureTabBar(){
        setViewControllers([homeVC, historyViewController, profileViewController], animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
