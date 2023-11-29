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
        buttonGesture()
    }
    
    private var disposeBag = DisposeBag()
    private lazy var rankAnimeVM = RankAnimeViewModel()
}

extension TopAnimeViewController: PagingViewControllerDataSource, PagingViewControllerDelegate {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return rankAnimeVM.tabBarItem.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        return TopAnimePagingView()
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        let data = rankAnimeVM.tabBarItem[index]
        return PagingIndexItem(index: index, title: data)
    }
}

extension TopAnimeViewController {
    func setUpPagingVC() {
        let pagingVC = PagingViewController(viewControllers: [TopAnimePagingView(), TopAnimePagingView(), TopAnimePagingView(), TopAnimePagingView()])
        pagingVC.configure(parent: self, nslayoutTopAnchor: appBar.bottomAnchor)
    }
    func buttonGesture() {
        backButton.rx.tap.subscribe(onNext: {_ in self.navigationController?.popToRootViewController(animated: true)
        }
        ).disposed(by: disposeBag)
    }
}
