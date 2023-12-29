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
    
    private func setUpPagingVC() {
        let pagingVC = PagingViewController(viewControllers: [AnimeSchedulePagingViewController(), AnimeSchedulePagingViewController(), AnimeSchedulePagingViewController(), AnimeSchedulePagingViewController(),AnimeSchedulePagingViewController(),AnimeSchedulePagingViewController(),AnimeSchedulePagingViewController()])
        pagingVC.configure(parent: self, nslayoutTopAnchor: appBar.bottomAnchor)
    }
    
    private func buttonGesture() {
        backButton.rx.tap.subscribe(onNext: {_ in self.navigationController?.popToRootViewController(animated: true)
        }
        ).disposed(by: disposeBag)
    }
}

extension AnimeScheduleViewController: PagingViewControllerDataSource, PagingViewControllerDelegate {
    
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return AnimeScheduleViewModel.shared.tabBarItem.count
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        let vc = AnimeSchedulePagingViewController()
        vc.index = index
        return vc
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        let data = AnimeScheduleViewModel.shared.tabBarItem[index]
        return PagingIndexItem(index: index, title: data)
    }
}
