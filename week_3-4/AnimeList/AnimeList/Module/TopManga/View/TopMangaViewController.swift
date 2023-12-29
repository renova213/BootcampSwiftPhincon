import UIKit
import RxSwift
import RxCocoa
import Parchment

class TopMangaViewController: UIViewController {
    
    @IBOutlet weak var appBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPagingVC()
        buttonGesture()
    }
    
    private let disposeBag = DisposeBag()
    
    private let topMangaVM = TopMangaViewModel()
    
    private func setUpPagingVC() {
        let pagingVC = PagingViewController()
        pagingVC.configure(parent: self, nslayoutTopAnchor: appBar.bottomAnchor)
    }
    
    private func buttonGesture() {
        backButton.rx.tap.subscribe(onNext: {_ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        ).disposed(by: disposeBag)
    }
}

extension TopMangaViewController: PagingViewControllerDataSource, PagingViewControllerDelegate {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return topMangaVM.tabBarItem.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let vc = TopMangaPagingViewController()
        vc.index = index
        return vc
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        let data = topMangaVM.tabBarItem[index]
        return PagingIndexItem(index: index, title: data)
    }
}
