import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splashTimer()
    }
    
    func splashTimer(){
        let token = TokenHelper().retrieveToken()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            if (token.isEmpty){
                let vc = AuthViewController()
                self.navigationController?.setViewControllers([vc], animated: true)
            }else{
                let vc = MainTabBarViewController()
                self.navigationController?.setViewControllers([vc], animated: true)
            }
        }
    }
}
