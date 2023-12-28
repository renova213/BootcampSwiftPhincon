import UIKit
import RxSwift
import RxCocoa

protocol DashboardCategoryItemDelegate: AnyObject{
    func didTapNavigateRankAnime(index: Int)
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
    var index: Int?
    
    private func configureComponentStyle(){
        categoryItemView.roundCornersAll(radius: 12)
        categoryButton.backgroundColor = UIColor(named: "Main Color")
    }
    
    func setUpButton(title: String, icon: UIImage){
        categoryButton.setTitle(title, for: .normal)
        categoryButton.setImage(icon, for: .normal)
    }
    
    private func buttonGesture(){
        categoryButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            
            if let currentIndex = self.index {
                self.delegate?.didTapNavigateRankAnime(index: currentIndex)
            }
        }).disposed(by: disposeBag)
    }
}
