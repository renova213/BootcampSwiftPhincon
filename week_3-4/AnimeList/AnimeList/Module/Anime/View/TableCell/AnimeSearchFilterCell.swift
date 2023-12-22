import UIKit
import RxSwift
import RxCocoa

protocol AnimeSearchFilterCellDelegate: AnyObject{
    func didTapNavigation()
    func didTapFilterPopUp()
}

class AnimeSearchFilterCell: UITableViewCell {
    
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var filterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        gestureButton()
    }
    private let disposeBag = DisposeBag()
    weak var delegate: AnimeSearchFilterCellDelegate?
    
    func configureUI(){
        searchBar.configureUI()
        filterButton.addBorder(width: 1, color: UIColor(named: "Main Color")!)
        filterButton.roundCornersAll(radius: 5)
    }
    
    func gestureButton(){
        searchBar.searchView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            self?.delegate?.didTapNavigation()
        }
        )
        .disposed(by: disposeBag)
        filterButton.rx.tap.subscribe(onNext: {_ in
            self.delegate?.didTapFilterPopUp()
        }).disposed(by: disposeBag)
    }
}
