import UIKit
import RxSwift
import RxCocoa
import Parchment

class TopAnimeViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var appBar: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPagingVC()
        configureGesture()
    }
    
    private let disposeBag = DisposeBag()
    private let topAnimeVM = TopAnimeViewModel()
    
    func setUpPagingVC() {
        let pagingVC = PagingViewController()
        pagingVC.configure(parent: self, nslayoutTopAnchor: appBar.bottomAnchor)
    }
    
    func configureGesture() {
        backButton.rx.tap.subscribe(onNext: {_ in self.navigationController?.popToRootViewController(animated: true)
        }
        ).disposed(by: disposeBag)
    }
}

extension TopAnimeViewController: PagingViewControllerDataSource, PagingViewControllerDelegate {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return topAnimeVM.tabBarItem.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let vc = TopAnimePagingView()
        vc.index = index
        return vc
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        let data = topAnimeVM.tabBarItem[index]
        return PagingIndexItem(index: index, title: data)
    }
}
