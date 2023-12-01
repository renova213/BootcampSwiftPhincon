import UIKit
import RxSwift
import RxCocoa

protocol AnimeSeasonYearCellDelegate: AnyObject {
    func didTapYear(index: Int)
}

class AnimeSeasonYearCell: UICollectionViewCell {
    
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var yearLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        buttonGesture()
    }
    
    weak var delegate: AnimeSeasonYearCellDelegate?
    private let disposeBag = DisposeBag()
    var index: Int?
    
    func initialSetup(year: String, selectedYearIndex: Int, index: Int){
        self.index = index
        
        yearLabel.text = year
        
        if(selectedYearIndex == index){
            self.itemView.layer.backgroundColor = UIColor.orange.cgColor
        }else{
            self.yearLabel.tintColor = UIColor.white
            self.itemView.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureUI(){
        itemView.isUserInteractionEnabled = true
        itemView.layer.borderWidth = 1.0
        itemView.layer.borderColor = UIColor.white.cgColor
        itemView.roundCornersAll(radius: 8)
    }
    
    func buttonGesture(){
        itemView.rx.tapGesture().when(.recognized).subscribe({[weak self] _ in
            guard let self = self else { return }
            if let index = self.index {
                self.delegate?.didTapYear(index: index)
            }
        }).disposed(by: disposeBag)
    }
}
