import UIKit
import RxSwift
import RxCocoa
import Parchment

class AnimeScheduleViewController: UIViewController {
    
    @IBOutlet weak var appBar: UIView!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonGesture()
        setUpPagingVC()
    }

    private let disposeBag = DisposeBag()
    private let animeCalendarVM = AnimeScheduleViewModel()
}

extension AnimeScheduleViewController: PagingViewControllerDataSource, PagingViewControllerDelegate {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return animeCalendarVM.tabBarItem.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let vc = AnimeSchedulePagingViewController(index: index)
        return vc
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        let data = animeCalendarVM.tabBarItem[index]
        return PagingIndexItem(index: index, title: data)
    }
}

extension AnimeScheduleViewController {
    func setUpPagingVC() {
        let pagingVC = PagingViewController(viewControllers: [AnimeSchedulePagingViewController(index: 0), AnimeSchedulePagingViewController(index: 1), AnimeSchedulePagingViewController(index: 2), AnimeSchedulePagingViewController(index: 3),AnimeSchedulePagingViewController(index: 4),AnimeSchedulePagingViewController(index: 5),AnimeSchedulePagingViewController(index: 6)])
        pagingVC.configure(parent: self, nslayoutTopAnchor: appBar.bottomAnchor)
    }
    func buttonGesture() {
        backButton.rx.tap.subscribe(onNext: {_ in self.navigationController?.popToRootViewController(animated: true)
        }
        ).disposed(by: disposeBag)
    }
}
