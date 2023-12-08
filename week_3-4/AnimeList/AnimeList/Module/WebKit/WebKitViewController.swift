import UIKit
import WebKit

class WebKitViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webKitView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebKit()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    var url: URL?
    
    func loadWebKit(){
        webKitView.navigationDelegate = self
        if let url = self.url {
            let request = URLRequest(url: url)
            webKitView.load(request)
        }
    }
}
