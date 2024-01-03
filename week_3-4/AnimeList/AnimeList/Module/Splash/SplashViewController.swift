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
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let appDelegate = windowScene.delegate as? SceneDelegate {
                if (token.isEmpty){
                    let vc = AuthViewController()
                    let navigationController = UINavigationController(rootViewController: vc)
                    appDelegate.window?.rootViewController = navigationController
                }else{
                    let vc = MainTabBarViewController()
                    let navigationController = UINavigationController(rootViewController: vc)
                    appDelegate.window?.rootViewController = navigationController
                }
                appDelegate.window?.makeKeyAndVisible()
            }
            
            
        }
    }
}
