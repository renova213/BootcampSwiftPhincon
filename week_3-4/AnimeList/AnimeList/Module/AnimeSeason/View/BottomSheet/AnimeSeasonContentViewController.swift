import UIKit
import RxSwift
import RxCocoa
import SkeletonView
protocol AnimeSeasonContentViewControllerDelegate: AnyObject{
    func didConfirm(sortIndex: Int, season: String, year: Int)
}

class AnimeSeasonContentViewController: UIViewController {
    
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var stackViewFilter: UIStackView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var yearCollection: UICollectionView!
    @IBOutlet weak var seasonCollection: UICollectionView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        resetData()
        buttonGesture()
        seasonLabel.fadeIn(duration: 0.3)
        AnimeSeasonViewModel.shared.changeSelectedSeason(season: "Winter")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        bindData()
    }
    
    private let disposeBag = DisposeBag()
    private var seasonList: [SeasonListEntity] = [] {
        didSet{
            yearCollection.reloadData()
        }
    }
    private var selectedYearIndex: Int = 0{
        didSet{
            yearCollection.reloadData()
            seasonCollection.reloadData()
        }
    }
    private var selectedSeasonIndex: Int = 0{
        didSet{
            yearCollection.reloadData()
            seasonCollection.reloadData()
        }
    }
    weak var delegate: AnimeSeasonContentViewControllerDelegate?
    
    private func resetData(){
        AnimeSeasonViewModel.shared.changeSelectedYearIndex(index: 0)
        AnimeSeasonViewModel.shared.changeSelectedSeasonIndex(index: 0)
        AnimeSeasonViewModel.shared.changeFilterStatus(index: 0)
    }
    
    private func buttonGesture(){
        filterButton.rx.tap.subscribe({_ in
            let currentFilterIndex = AnimeSeasonViewModel.shared.filterIndex.value
            if(currentFilterIndex == 0){
                AnimeSeasonViewModel.shared.changeFilterStatus(index: 1)
            }
            if(currentFilterIndex == 1){
                AnimeSeasonViewModel.shared.changeFilterStatus(index: 2)
            }
            if(currentFilterIndex == 2){
                AnimeSeasonViewModel.shared.changeFilterStatus(index: 1)
            }
        }).disposed(by: disposeBag)
        confirmButton.rx.tap.subscribe({[weak self] _ in
            guard let self = self else { return }
            self.delegate?.didConfirm(sortIndex: AnimeSeasonViewModel.shared.filterIndex.value, season: AnimeSeasonViewModel.shared.selectedSeason.value, year: AnimeSeasonViewModel.shared.selectedYear.value)
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        cancelButton.rx.tap.subscribe({[weak self] _ in
            guard let self = self else { return }
            self.resetData()
        }).disposed(by: disposeBag)
    }
    
    private func configureUI(){
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        confirmButton.roundCornersAll(radius: 12)
        cancelButton.addBorder(width: 1, color: UIColor.white)
        cancelButton.roundCornersAll(radius: 8)
        filterButton.addBorder(width: 1, color: UIColor.white)
        filterButton.roundCornersAll(radius: 8)
    }
    
    private func configureCollection(){
        seasonCollection.delegate = self
        seasonCollection.dataSource = self
        seasonCollection.registerCellWithNib(AnimeSeasonItemCell.self)
        
        yearCollection.delegate = self
        yearCollection.dataSource = self
        yearCollection.registerCellWithNib(AnimeSeasonYearCell.self)
    }
    
    private func loadData(){
        AnimeSeasonViewModel.shared.loadData(for: Endpoint.getSeasonList, resultType: SeasonListResponse.self, sortIndex: 0)
    }
    
    private func bindData(){
        AnimeSeasonViewModel.shared.seasonList.asObservable().subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            self.seasonList = data
        }).disposed(by: disposeBag)
        AnimeSeasonViewModel.shared.selectedYearIndex.asObservable().subscribe(onNext: {[weak self] i in
            guard let self = self else { return }
            self.selectedYearIndex = i
        }).disposed(by: disposeBag)
        AnimeSeasonViewModel.shared.selectedSeasonIndex.asObservable().subscribe(onNext: {[weak self] i in
            guard let self = self else { return }
            self.selectedSeasonIndex = i
        }).disposed(by: disposeBag)
        AnimeSeasonViewModel.shared.selectedSeason.asObservable().subscribe(onNext: {[weak self] season in
            guard let self = self else { return }
            self.seasonLabel.text = season
        }).disposed(by: disposeBag)
        AnimeSeasonViewModel.shared.filterIndex.subscribe({[weak self] index in
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
        AnimeSeasonViewModel.shared.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                self.stackViewFilter.showAnimatedGradientSkeleton()
                self.yearCollection.showAnimatedGradientSkeleton()
            case .finished, .initial, .empty, .failed:
                self.yearCollection.hideSkeleton()
            }
        }).disposed(by: disposeBag)
    }
}

extension AnimeSeasonContentViewController: AnimeSeasonYearCellDelegate, AnimeSeasonItemCellDelegate {
    func didTapYear(index: Int, year: Int) {
        AnimeSeasonViewModel.shared.changeSelectedYearIndex(index: index)
        AnimeSeasonViewModel.shared.changeSelectedSeasonIndex(index: 0)
        AnimeSeasonViewModel.shared.changeSelectedYear(year: year)
        AnimeSeasonViewModel.shared.changeSelectedSeason(season: AnimeSeasonViewModel.shared.selectedSeason.value)
        AnimeSeasonViewModel.shared.changeSelectedSeason(season: "Winter")
        seasonLabel.fadeIn(duration: 0.3)
    }
    
    func didTapSeason(index: Int, season: String) {
        AnimeSeasonViewModel.shared.changeSelectedSeasonIndex(index: index)
        AnimeSeasonViewModel.shared.changeSelectedSeason(season: season.capitalized)
        seasonLabel.fadeIn(duration: 0.3)
    }
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
        case seasonCollection: return seasonList.isEmpty ? 0 : seasonList[self.selectedYearIndex].seasons.count
        case yearCollection: return seasonList.count
        default: return 0
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
            let totalCell = seasonList.isEmpty ? 0 : seasonList[self.selectedYearIndex].seasons.count
            
            let totalCellWidth = 50 * totalCell
            let totalSpacingWidth = 20 * (totalCell - 1)
            
            let leftInset = (collectionView.bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
            let rightInset = leftInset
            
            return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
