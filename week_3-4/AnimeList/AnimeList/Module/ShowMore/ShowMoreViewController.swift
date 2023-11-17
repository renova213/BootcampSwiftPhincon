import UIKit
import RxSwift
import RxCocoa


class ShowMoreViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var showMoreCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setUpComponent()
        clearAnimeData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFetchViewModel(typeGet: typeGet ?? "")
        bindFetchViewModel()
    }
    
    var animeData: [AnimeEntity] = []{
        didSet{
            showMoreCollection.reloadData()
        }
    }
    var typeGet: String?
    
    let disposeBag = DisposeBag()
}

extension ShowMoreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        vc.animeData = data

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
    
    func getFetchViewModel(typeGet: String){
        
                switch typeGet {
                case "seasonNow":
                    AnimeViewModel.shared.getShowMoreAnime(endpoint: Endpoint.getSeasonNow(page: "1", limit: "25"))
                case "currentAnime":
                    AnimeViewModel.shared.getShowMoreAnime(endpoint: Endpoint.getScheduledAnime(params: ScheduleParam(filter: AnimeViewModel.shared.getCurrentDay().lowercased(), page: "1", limit: "25")))
                default:
                    animeData = []
                }
    }
    
    func bindFetchViewModel() {
        AnimeViewModel.shared.showMoreAnime
            .subscribe(onNext: { [weak self] i in
                
                self?.animeData = i
            })
            .disposed(by: disposeBag)
    }
    
    func clearAnimeData(){
        AnimeViewModel.shared.showMoreAnime.accept([])
    }
}
