import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class UpdateMangaListBottomSheet: UIViewController {
    
    @IBOutlet weak var chapterField: UITextField!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var scoreCollection: UICollectionView!
    @IBOutlet weak var increamentButton: UIButton!
    @IBOutlet weak var decreamentButton: UIButton!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.dismissImmediately()
        buttonGesture()
        configureUI()
        configureCollectionView()
        MangaViewModel.shared.loadingState2.accept(.initial)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindData()
    }
    
    func setContentHeight(_ height: CGFloat) {
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    var userManga: UserMangaEntity?
    lazy var loadingIndicator = PopUpLoading(on: view)
    private let disposeBag = DisposeBag()
    private lazy var selectedScoreIndex = 0{
        didSet{
            scoreCollection.reloadData()
        }
    }
}

extension UpdateMangaListBottomSheet: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func configureCollectionView(){
        scoreCollection.delegate = self
        scoreCollection.dataSource = self
        scoreCollection.registerCellWithNib(MangaRatingScoreItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MangaViewModel.shared.scoreList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = MangaViewModel.shared.scoreList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MangaRatingScoreItem
        cell.configureBorder(state: selectedScoreIndex == indexPath.row)
        cell.scoreLabel.text = String(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MangaViewModel.shared.changeSelectedIndexScore(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 35)
    }
}

extension UpdateMangaListBottomSheet{
    
    private func buttonGesture(){
        closeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            
            self.dismiss(animated: true, completion: nil)
        }
        ).disposed(by: disposeBag)
        
        increamentButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self, let chapter = self.userManga?.manga.chapters else { return }
            
            MangaViewModel.shared.increamentEpisode(totalEpisode: chapter)
        }
                                          
        ).disposed(by: disposeBag)
        decreamentButton.rx.tap.subscribe(onNext: {_ in
            MangaViewModel.shared.decreamentEpisode()
        }
                                          
        ).disposed(by: disposeBag)
        
        statusButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            let bottomSheetVC = MangaWatchStatusPopUp()
            self.present(bottomSheetVC, animated: true)
        }
        ).disposed(by: disposeBag)
        
        updateButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let userManga = self.userManga else { return }
            MangaViewModel.shared.loadData(for: Endpoint.putUserManga(params: UpdateUserMangaParam(id: userManga.id, userEpisode: MangaViewModel.shared.episode.value, watchStatus: MangaViewModel.shared.selectedSwatchStatusIndex.value, userScore: MangaViewModel.shared.selectedIndexScore.value + 1)), resultType: UserMangaResponse.self)
        }
        ).disposed(by: disposeBag)
    }
    
    private func configureUI(){
        bottomSheetView.roundCornersAll(radius: 24)
        scoreView.roundCornersAll(radius: 8)
        MangaViewModel.shared.resetBottomSheet()
    }
    
    func initialData(userManga: UserMangaEntity){
        titleLabel.text = userManga.manga.title
        MangaViewModel.shared.changeSelectedIndexScore(index: userManga.userScore - 1)
        MangaViewModel.shared.changeMessageRating()
        MangaViewModel.shared.changeSelectedStatusIndex(index: userManga.watchStatus)
        MangaViewModel.shared.changeTitleWatchStatus()
        MangaViewModel.shared.episode.accept(userManga.userEpisode)
        
        if let url = URL(string: userManga.manga.images?.jpg?.imageUrl ?? ""){
            urlImage.kf.setImage(with: url, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
    
    private func bindData() {
        MangaViewModel.shared.selectedIndexScore
            .subscribe(onNext: { [weak self] i in
                guard let self = self else { return }
                
                self.selectedScoreIndex = i
            })
            .disposed(by: disposeBag)
        
        MangaViewModel.shared.episode
            .subscribe(onNext: { [weak self] i in
                guard let self = self else { return }
                
                self.chapterField.text = String(i)
            })
            .disposed(by: disposeBag)
        MangaViewModel.shared.messageRating
            .subscribe(onNext: { [weak self] i in
                guard let self = self else { return }
                
                self.ratingLabel.text = String(i)
            })
            .disposed(by: disposeBag)
        MangaViewModel.shared.selectedStatus
            .subscribe(onNext: { [weak self] i in
                guard let self = self else { return }
                
                self.statusButton.setTitle(i, for: .normal)
            })
            .disposed(by: disposeBag)
        MangaViewModel.shared.loadingState2.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loading:
                self.updateButton.isEnabled = false
                self.loadingIndicator.showInFull()
                break
            case .initial:
                break
            case .empty:
                break
            case .finished:
                self.loadingIndicator.dismissImmediately()
                self.updateButton.isEnabled = true
                self.presentSuccessPopUp(message: "Data updated successfully")
                MangaViewModel.shared.reloadDataRelay.accept(MangaViewModel.shared.userMangaList.value)
                break
            case .failed:
                self.loadingIndicator.dismissImmediately()
                self.updateButton.isEnabled = true
                self.presentFailedPopUp(message: MangaViewModel.shared.errorMessage.value)
                break
            }
        }).disposed(by: disposeBag)
    }
}
