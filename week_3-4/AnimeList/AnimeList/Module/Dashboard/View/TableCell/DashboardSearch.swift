import UIKit
import RxSwift
import RxCocoa
import RxGesture

protocol DashboardSearchDelegate: AnyObject {
    func didSelectCell()
}

class DashboardSearch: UITableViewCell {
    
    @IBOutlet weak var gestureStackView: UIStackView!
    @IBOutlet weak var dashboardSearchView: UIView!
    @IBOutlet weak var dashboardSearchField: UITextField!
    
    weak var delegate: DashboardSearchDelegate?
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        configureGesture()
    }
    
    private func configureUI() {
        gestureStackView.isUserInteractionEnabled = true
        
        dashboardSearchField.borderStyle = .none
        
        dashboardSearchView.roundCornersAll(radius: 15)
        dashboardSearchView.layer.borderWidth = 1
        dashboardSearchView.layer.borderColor = UIColor(named: "Main Color")?.cgColor
        
        dashboardSearchField.isEnabled = false
    }
    
    private func configureGesture() {
        gestureStackView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.didSelectCell()
            })
            .disposed(by: disposeBag)
    }
}
