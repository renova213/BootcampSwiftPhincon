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
        setUpComponent()
        clearAnimeData()
        fetchData(typeGet: typeGet ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindData()
    }
    
    var animeData: [AnimeEntity] = []{
        didSet{
            showMoreCollection.reloadData()
        }
    }
    let showMoreVM = ShowMoreViewModel.shared
    var typeGet: String?
    
    let disposeBag = DisposeBag()
}

extension ShowMoreViewController: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return "ShowMoreItem"
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowMoreItem", for: indexPath) as! ShowMoreItem
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

extension ShowMoreViewController {
    func setUpComponent(){
        tapBackButton()
    }
    
    func tapBackButton(){
        backButton.rx.tap.subscribe(onNext:  {_  in
            self.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func fetchData(typeGet: String){
        self.showMoreCollection.showAnimatedGradientSkeleton()
        
        switch typeGet {
        case "seasonNow":
            showMoreVM.loadData(for: Endpoint.getSeasonNow(page: "1", limit: "25"), resultType: AnimeResponse.self)
            
        case "currentAnime":
            showMoreVM.loadData(for: Endpoint.getSeasonNow(page: "1", limit: "25"), resultType: AnimeResponse.self)
        default:
            animeData = []
        }
    }
    
    func bindData() {
        showMoreVM.showMoreAnime.asObservable()
            .subscribe(onNext: { [weak self] i in
                
                self?.animeData = i
            })
            .disposed(by: disposeBag)
        showMoreVM.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case .notLoad, .loading:
                self.showMoreCollection.showAnimatedGradientSkeleton()
            case .failed, .finished:
                DispatchQueue.main.async {
                    self.showMoreCollection.hideSkeleton()
                }
            }
        }
        ).disposed(by: disposeBag)
    }
    
    func clearAnimeData(){
        showMoreVM.showMoreAnime.accept([])
    }
}
