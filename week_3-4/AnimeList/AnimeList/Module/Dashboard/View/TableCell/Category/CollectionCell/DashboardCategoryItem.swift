import UIKit
import RxSwift
import RxCocoa

protocol DashboardCategoryItemDelegate: AnyObject{
    func didTapNavigateRankAnime()
}

class DashboardCategoryItem: UICollectionViewCell {

    @IBOutlet weak var categoryItemView: UIView!
    @IBOutlet weak var categoryButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponentStyle()
        buttonGesture()
    }
    
    weak var delegate: DashboardCategoryItemDelegate?
    private let disposeBag = DisposeBag()
    
    func configureComponentStyle(){
        categoryItemView.roundCornersAll(radius: 12)
        categoryButton.backgroundColor = UIColor(named: "Main Color")
    }
    
    func setUpButton(title: String, icon: UIImage){
        categoryButton.setTitle(title, for: .normal)
        categoryButton.setImage(icon, for: .normal)
    }
    
    func buttonGesture(){
        categoryButton.rx.tap.subscribe(onNext: {_ in
            print("dasdasdasdas")
            self.delegate?.didTapNavigateRankAnime()
        }).disposed(by: disposeBag)
    }
}
