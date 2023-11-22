import UIKit
import RxSwift
import RxCocoa

class addToListBottomSheet: UIViewController {
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var increamentButton: UIButton!
    @IBOutlet weak var decreamentButton: UIButton!
    @IBOutlet weak var episodeLabel: UITextField!
    @IBOutlet weak var selectStatus: UIButton!
    @IBOutlet weak var selectScore: UIButton!
    @IBOutlet weak var messageScoreLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scoreCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonGesture()
        configureUI()
        configureCollectionView()
        bindViewModel()
    }
    
    func setContentHeight(_ height: CGFloat) {
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    let disposeBag = DisposeBag()
    var selectedScoreIndex = 0{
        didSet{
            scoreCollection.reloadData()
        }
    }
}

extension addToListBottomSheet: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 35)
    }
}

extension addToListBottomSheet{
    func buttonGesture(){
        closeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
        ).disposed(by: disposeBag)
        
        increamentButton.rx.tap.subscribe(onNext: {_ in
            DetailAnimeViewModel.shared.increamentEpisode(totalEpisode: 20)
        }
                                          
        ).disposed(by: disposeBag)
        decreamentButton.rx.tap.subscribe(onNext: {_ in
            DetailAnimeViewModel.shared.decreamentEpisode()
        }
                                          
        ).disposed(by: disposeBag)
        
        statusButton.rx.tap.subscribe(onNext: { [weak self] in
            let bottomSheetVC = WatchStatusBottomSheet()
            bottomSheetVC.setContentHeight(bottomSheetVC.view.bounds.height)
            self?.presentBottomSheet(contentViewController: bottomSheetVC)
        }
        ).disposed(by: disposeBag)
    }
    
    func configureUI(){
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        messageScoreLabel.isHidden = true
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
    }
}

