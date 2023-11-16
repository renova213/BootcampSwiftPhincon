//
//  SplashViewController.swift
//  AnimeList
//
//  Created by Phincon on 10/11/23.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        splashTimer()
    }
    
    func splashTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            let vc = MainTabBarViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
}
