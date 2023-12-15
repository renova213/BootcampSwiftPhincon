import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class AddToListBottomSheet: UIViewController {
    
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var scoreCollection: UICollectionView!
    @IBOutlet weak var messageScoreLabel: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var addToListButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var increamentButton: UIButton!
    @IBOutlet weak var decreamentButton: UIButton!
    @IBOutlet weak var episodeLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.dismissImmediately()
        buttonGesture()
        configureUI()
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bindViewModel()
    }
    
    func setContentHeight(_ height: CGFloat) {
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    var imageUrl: String?
    var malId: Int?
    var totalEpisode: Int?
    lazy var loadingIndicator = PopUpLoading(on: view)
    let disposeBag = DisposeBag()
    var selectedScoreIndex = 0{
        didSet{
            scoreCollection.reloadData()
        }
    }
}

extension AddToListBottomSheet: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func configureCollectionView(){
        scoreCollection.delegate = self
        scoreCollection.dataSource = self
        scoreCollection.registerCellWithNib(RatingScoreItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DetailAnimeViewModel.shared.scoreList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = DetailAnimeViewModel.shared.scoreList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingScoreItem", for: indexPath) as! RatingScoreItem
        cell.configureBorder(state: selectedScoreIndex == indexPath.row)
        cell.scoreLabel.text = String(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DetailAnimeViewModel.shared.changeSelectedIndexScore(index: indexPath.row)
        DetailAnimeViewModel.shared.changeMessageRating()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 35)
    }
}

extension AddToListBottomSheet{
    
    func buttonGesture(){
        closeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.dismiss(animated: false, completion: nil)
        }
        ).disposed(by: disposeBag)
        
        increamentButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            
            if let totalEpisode = self.totalEpisode {
                DetailAnimeViewModel.shared.increamentEpisode(totalEpisode: totalEpisode)
            }
        }).disposed(by: disposeBag)
        
        decreamentButton.rx.tap.subscribe(onNext: {_ in
            DetailAnimeViewModel.shared.decreamentEpisode()
        }).disposed(by: disposeBag)
        
        statusButton.rx.tap.subscribe(onNext: { [weak self] in
            let bottomSheetVC = WatchStatusBottomSheet()
            bottomSheetVC.imageUrl = self?.imageUrl
            bottomSheetVC.setContentHeight(bottomSheetVC.view.bounds.height)
            self?.presentBottomSheet(contentViewController: bottomSheetVC)
        }).disposed(by: disposeBag)
        
        addToListButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.addToListButton.isEnabled = false
            self.loadingIndicator.showInFull()
            
            if let id = self.malId, let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults(){
                UserAnimeViewModel.shared.postUserAnime(body: UserAnimeParam(userId: userId, malId: id, userScore: DetailAnimeViewModel.shared.selectedIndexScore.value + 1, userEpisode: DetailAnimeViewModel.shared.episode.value, watchStatus: DetailAnimeViewModel.shared.selectedSwatchStatusIndex.value)){[weak self] result in
                    
                    guard let self = self else { return }
                    
                    switch result {
                    case .success:
                        self.addToListButton.isEnabled = true
                        self.loadingIndicator.dismissImmediately()
                        self.presentSuccessPopUp(message: "Successfully added to list")
                        break
                    case .failure(let error):
                        self.addToListButton.isEnabled = true
                        self.loadingIndicator.dismissImmediately()
                        if let error = error as? CustomError{
                            self.presentFailedPopUp(message: error.message)
                        }
                        break
                    }
                }
            }
        }
        ).disposed(by: disposeBag)
    }
    
    func configureUI(){
        bottomSheetView.roundCornersAll(radius: 24)
        scoreView.roundCornersAll(radius: 8)
        if let url = URL(string: imageUrl ?? ""){
            urlImage.kf.setImage(with: url, placeholder: UIImage(named: "ImagePlaceholder"))
        }
        DetailAnimeViewModel.shared.resetBottomSheet()
    }
    
    func bindViewModel() {
        DetailAnimeViewModel.shared.selectedIndexScore
            .subscribe(onNext: { [weak self] i in
                
                self?.selectedScoreIndex = i
            })
            .disposed(by: disposeBag)
        
        DetailAnimeViewModel.shared.episode
            .subscribe(onNext: { [weak self] i in
                
                self?.episodeLabel.text = String(i)
            })
            .disposed(by: disposeBag)
        DetailAnimeViewModel.shared.messageRating
            .subscribe(onNext: { [weak self] i in
                
                self?.messageScoreLabel.text = String(i)
            })
            .disposed(by: disposeBag)
        DetailAnimeViewModel.shared.selectedStatus
            .subscribe(onNext: { [weak self] i in
                
                self?.statusButton.setTitle(i, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
