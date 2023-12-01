import UIKit
import RxSwift
import RxCocoa
import SkeletonView
protocol AnimeSeasonContentViewControllerDelegate: AnyObject{
    func didConfirm(index: Int)
}

class AnimeSeasonContentViewController: UIViewController {
    
    @IBOutlet weak var stackViewFilter: UIStackView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var yearCollection: UICollectionView!
    @IBOutlet weak var seasonCollection: UICollectionView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadData()
        resetData()
        buttonGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureCollection()
    }
    
    private let disposeBag = DisposeBag()
    private let animeSeasonVM = AnimeSeasonViewModel()
    var seasonList: [SeasonListEntity] = [] {
        didSet{
            yearCollection.reloadData()
        }
    }
    var selectedYearIndex: Int = 0{
        didSet{
            yearCollection.reloadData()
            seasonCollection.reloadData()
        }
    }
    var selectedSeasonIndex: Int = 0{
        didSet{
            yearCollection.reloadData()
            seasonCollection.reloadData()
        }
    }
    weak var delegate: AnimeSeasonContentViewControllerDelegate?
}

extension AnimeSeasonContentViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch skeletonView {
        case seasonCollection:
            return String(describing: AnimeSeasonItemCell.self)
        case yearCollection:
            return String(describing: AnimeSeasonYearCell.self)
        default:
            return String(describing: UICollectionViewCell().self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case seasonCollection:
            return seasonList[self.selectedYearIndex].seasons.count
        case yearCollection:
            return seasonList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case seasonCollection:
            let data = seasonList[selectedYearIndex].seasons[indexPath.row]
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as AnimeSeasonItemCell
            cell.initialSetup(season: data, selectedSeasonIndex: selectedSeasonIndex, index: indexPath.row)
            cell.delegate = self
            cell.rotate360Degrees(duration: 1)
            return cell
        case yearCollection:
            let data = seasonList[indexPath.row]
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as AnimeSeasonYearCell
            cell.initialSetup(year: String(data.year), selectedYearIndex: selectedYearIndex, index: indexPath.row)
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case seasonCollection:
            return CGSize(width: 50, height: 50)
        case yearCollection:
            let data = seasonList[indexPath.row]
            
            let label = UILabel()
            
            label.text = String(data.year)
            
            label.sizeToFit()
            let extraSpacing: CGFloat = 30
            
            return CGSize(width: label.frame.width + extraSpacing, height: 40)
        default:
            return CGSize(width: 50, height: 50)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == seasonCollection {
            let totalCell = seasonList[selectedYearIndex].seasons.count
            
            let totalCellWidth = 50 * totalCell
            let totalSpacingWidth = 20 * (totalCell - 1)
            
            let leftInset = (collectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension AnimeSeasonContentViewController{
    func resetData(){
        animeSeasonVM.changeSelectedYearIndex(index: 0)
        animeSeasonVM.changeSelectedSeasonIndex(index: 0)
        animeSeasonVM.changeFilterStatus(index: 0)
    }
    
    func buttonGesture(){
        filterButton.rx.tap.subscribe({[weak self] _ in
            guard let self = self else { return }
            let currentFilterIndex = self.animeSeasonVM.filterIndex.value
            if(currentFilterIndex == 0){
                self.animeSeasonVM.changeFilterStatus(index: 1)
            }
            if(currentFilterIndex == 1){
                self.animeSeasonVM.changeFilterStatus(index: 2)
            }
            if(currentFilterIndex == 2){
                self.animeSeasonVM.changeFilterStatus(index: 1)
            }
        }).disposed(by: disposeBag)
        confirmButton.rx.tap.subscribe({[weak self] _ in
            guard let self = self else { return }
            self.delegate?.didConfirm(index: self.animeSeasonVM.filterIndex.value)
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        cancelButton.rx.tap.subscribe({[weak self] _ in
            guard let self = self else { return }
            self.resetData()
        }).disposed(by: disposeBag)
    }
    
    func configureUI(){
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        confirmButton.roundCornersAll(radius: 12)
        cancelButton.addBorder(width: 1, color: UIColor.white)
        cancelButton.roundCornersAll(radius: 8)
        filterButton.addBorder(width: 1, color: UIColor.white)
        filterButton.roundCornersAll(radius: 8)
        
    }
    func configureCollection(){
        seasonCollection.delegate = self
        seasonCollection.dataSource = self
        seasonCollection.registerCellWithNib(AnimeSeasonItemCell.self)
        
        yearCollection.delegate = self
        yearCollection.dataSource = self
        yearCollection.registerCellWithNib(AnimeSeasonYearCell.self)
    }
    func loadData(){
        animeSeasonVM.loadData(for: Endpoint.getSeasonList, resultType: SeasonListResponse.self, index: 0)
    }
    func bindData(){
        animeSeasonVM.seasonList.asObservable().subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            self.seasonList = data
        }).disposed(by: disposeBag)
        animeSeasonVM.selectedYearIndex.asObservable().subscribe(onNext: {[weak self] i in
            guard let self = self else { return }
            self.selectedYearIndex = i
        }).disposed(by: disposeBag)
        animeSeasonVM.selectedSeasonIndex.asObservable().subscribe(onNext: {[weak self] i in
            guard let self = self else { return }
            self.selectedSeasonIndex = i
        }).disposed(by: disposeBag)
        animeSeasonVM.filterIndex.subscribe({[weak self] index in
            guard let self = self else { return }
            switch index.element {
            case 1:
                self.filterButton.setTitle("A-Z", for: .normal)
            case 2:
                self.filterButton.setTitle("Z-A", for: .normal)
            default:
                self.filterButton.setTitle("Select", for: .normal)
            }
        }).disposed(by: disposeBag)
    }
    func loadingState(){
        animeSeasonVM.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                self.stackViewFilter.showAnimatedGradientSkeleton()
                self.yearCollection.showAnimatedGradientSkeleton()
            case .finished, .notLoad, .failed:
                self.yearCollection.hideSkeleton()
            }
        }).disposed(by: disposeBag)
    }
}

extension AnimeSeasonContentViewController: AnimeSeasonYearCellDelegate, AnimeSeasonItemCellDelegate {
    func didTapYear(index: Int) {
        animeSeasonVM.changeSelectedYearIndex(index: index)
        animeSeasonVM.changeSelectedSeasonIndex(index: 0)
    }
    
    func didTapSeason(index: Int) {
        animeSeasonVM.changeSelectedSeasonIndex(index: index)
    }
}
