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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        configureGesture()
    }
    
    weak var delegate: DashboardSearchDelegate?
    let disposeBag = DisposeBag()
    
    func configureUI(){
        gestureStackView.isUserInteractionEnabled = true
        
        dashboardSearchField.borderStyle = .none

        dashboardSearchView.roundCornersAll(radius: 15)
        dashboardSearchView.layer.borderWidth = 1
        dashboardSearchView.layer.borderColor = UIColor.init(named: "Main Color")?.cgColor
        
        dashboardSearchField.isEnabled = false
    }
    
    func configureGesture(){
        gestureStackView.rx
                    .tapGesture()
                    .when(.recognized)
                    .subscribe(onNext: { [weak self] _ in
                        self?.delegate?.didSelectCell()
                    })
                    .disposed(by: disposeBag)
    }
}
