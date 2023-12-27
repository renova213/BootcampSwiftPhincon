import UIKit
import RxSwift
import RxCocoa

class MangaSearchFilterCell: UITableViewCell {
    
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var filterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        gestureButton()
    }
    private let disposeBag = DisposeBag()
    var mangaVM: MangaViewModel?
    
    func configureUI(){
        searchBar.configureUI()
        filterButton.addBorder(width: 1, color: UIColor(named: "Main Color")!)
        filterButton.roundCornersAll(radius: 5)
    }
    
    func gestureButton(){
        searchBar.searchView.rx.tapGesture().when(.recognized).subscribe(onNext: {_ in
            MangaViewModel.shared.navigateSearchViewRelay.onNext(())
        }
        )
        .disposed(by: disposeBag)
    }
}
