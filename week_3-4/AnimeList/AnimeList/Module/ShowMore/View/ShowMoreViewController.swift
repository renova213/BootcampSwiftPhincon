import UIKit
import RxSwift
import RxCocoa
import SkeletonView
import Hero

class ShowMoreViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var showMoreCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureGesture()
        loadData(typeGet: typeGet ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindData()
        super.viewWillAppear(animated)
    }
    
    var animeData: [AnimeEntity] = []{
        didSet{
            showMoreCollection.reloadData()
        }
    }
    
    var typeGet: String?
    
    private let disposeBag = DisposeBag()
    
    private func configureGesture(){
        backButton.rx.tap.subscribe(onNext:  {_  in
            self.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func loadData(typeGet: String){
        self.showMoreCollection.showAnimatedGradientSkeleton()
        
        switch typeGet {
        case "seasonNow":
            ShowMoreViewModel.shared.loadData(for: Endpoint.getSeasonNow(params: SeasonNowParam(page: "1", limit: "25")), resultType: AnimeResponse.self)
            break
        case "currentAnime":
            let scheduledParams = ScheduleParam(filter: Date.getCurrentDay().lowercased(), limit: "25")
            ShowMoreViewModel.shared.loadData(for: Endpoint.getScheduledAnime(params: scheduledParams), resultType: AnimeResponse.self)
            break
        default:
            animeData = []
        }
    }
    
    private func bindData() {
        ShowMoreViewModel.shared.showMoreAnime.asObservable()
            .subscribe(onNext: { [weak self] i in
                
                self?.animeData = i
            })
            .disposed(by: disposeBag)
        ShowMoreViewModel.shared.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case .initial, .empty:
                break
            case .loading:
                self.showMoreCollection.showAnimatedGradientSkeleton()
            case .finished:
                self.showMoreCollection.hideSkeleton()
                break
            case .failed:
                self.refreshPopUp(message: ShowMoreViewModel.shared.errorMessage.value)
            }
        }
        ).disposed(by: disposeBag)
    }
    
    private func refreshPopUp(message: String){
        let vc = RefreshPopUp()
        vc.setContentHeight(vc.view.bounds.height)
        vc.errorLabel.text = message
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
}

extension ShowMoreViewController: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: ShowMoreItem.self)
    }
    
    func configureTableView(){
        showMoreCollection.delegate = self
        showMoreCollection.dataSource = self
        showMoreCollection.registerCellWithNib(ShowMoreItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = animeData[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ShowMoreItem
        cell.animeCardItem.rankView.backgroundColor = UIColor.lightGray
        cell.initialSetupAnime(data: data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width / 3) - 8
        let height = width * 1.8
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = animeData[indexPath.row]
        let vc = DetailAnimeViewController()
        navigationController?.hero.isEnabled = true
        vc.malId = data.malId
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ShowMoreViewController: RefreshPopUpDelegate{
    func didTapRefresh() {
        self.dismiss(animated: false)
        loadData(typeGet: typeGet ?? "")
    }
}
