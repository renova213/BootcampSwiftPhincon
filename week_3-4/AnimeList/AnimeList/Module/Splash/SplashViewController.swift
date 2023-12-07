import UIKit
import Lottie

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        splashTimer()
    }
    
    func splashTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            let vc = AuthViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
}
