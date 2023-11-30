import UIKit
import RxSwift
import RxCocoa

class TopMangaViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonGesture()
    }
    private let disposeBag = DisposeBag()
}

extension TopMangaViewController{
    func buttonGesture() {
        backButton.rx.tap.subscribe(onNext: {_ in self.navigationController?.popToRootViewController(animated: true)
        }
        ).disposed(by: disposeBag)
    }
}
