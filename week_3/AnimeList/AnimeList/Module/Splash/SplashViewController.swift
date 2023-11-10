//
//  SplashViewController.swift
//  AnimeList
//
//  Created by Phincon on 10/11/23.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    @IBOutlet var lottieSplash: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLottie()
        splashTimer()
       
    }
    
    func splashTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            let vc = MainTabBarViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    func configureLottie(){
        lottieSplash = .init(name: "SplashLottie")
        
        lottieSplash!.frame = view.bounds
        
        lottieSplash!.loopMode = .playOnce
        
        lottieSplash!.animationSpeed = 0.5
        view.addSubview(lottieSplash!)
        
        lottieSplash!.play(fromFrame: 1, toFrame: 40, loopMode: .playOnce)
    }
}
