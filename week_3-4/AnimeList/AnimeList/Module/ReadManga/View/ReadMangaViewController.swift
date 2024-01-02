import UIKit
import RxSwift
import RxCocoa

class ReadMangaViewController: UIViewController {
    @IBOutlet weak var settingMenu: UIMenu!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var bottomBarView: UIView!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var appBarView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        loadData()
        configureGesture()
        configureMenu()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    private let readMangaVM = ReadMangaViewModel()
    private let disposeBag = DisposeBag()
    
    var chapterId: String?
    var mangaTitle: String?
    
    var settingMenus: UIMenu {
        let horizontalAction = UIAction(title: "Horizontal", handler: { _ in
            self.switchToHorizontalLayout()
        })
        
        let verticalAction = UIAction(title: "Vertical", handler: { _ in
            self.switchToVerticalLayout()
        })
        
        let menu = UIMenu(children: [horizontalAction, verticalAction])
        return menu
    }
    
    func initialTitle(title: String){
        titleLabel.text = title
    }
}

extension ReadMangaViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return readMangaVM.chapterImages.value?.chapter.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = readMangaVM.chapterImages.value
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ReadMangaViewCell
        if let data = data {
            cell.initialSetup(urlImage: "\(data.baseUrl)/data/\(data.chapter.hash)/\(data.chapter.data[indexPath.row])")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage: Int
        if readMangaVM.slideMode.value == false {
                    currentPage = Int(scrollView.contentOffset.y / scrollView.frame.size.height)
                } else {
                    currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
                }
                
                let sliderValue = Float(currentPage + 1)
                slider.value = sliderValue
                episodeLabel.text = "\(Int(sliderValue)) / \(readMangaVM.chapterLength())"
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch readMangaVM.viewState.value {
        case true:
            readMangaVM.changeViewState(state: false)
            appBarView.fadeOut()
            bottomBarView.fadeOut()
            break
        case false:
            readMangaVM.changeViewState(state: true)
            appBarView.isHidden = false
            appBarView.fadeIn()
            bottomBarView.fadeIn()
            break
        }
    }
    
}

extension ReadMangaViewController {
    func loadData(){
        if let chapterId = self.chapterId {
            readMangaVM.loadData(for: Endpoint.getMangaChapterImage(params: MangaChapterImageParam(chapterId: chapterId)), resultType: MangaChapterImageResponse.self)
        }
        
        if let mangaTitle = self.mangaTitle{
            titleLabel.text = mangaTitle
        }
    }
    
    func bindData(){
        readMangaVM.loadingState.subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading, .initial, .empty:
                break
            case .finished:
                self.collectionView.reloadData()
                self.configureSlider()
                break
            case .failed:
                self.refreshPopUp(message: self.readMangaVM.errorMessage.value)
            }
        }).disposed(by: disposeBag)
    }
    
    func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellWithNib(ReadMangaViewCell.self)
    }
    
    func configureGesture(){
        backButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func configureMenu() {
        settingButton.showsMenuAsPrimaryAction = true
        settingButton.menu = settingMenus
        settingButton.changesSelectionAsPrimaryAction = true
    }
    
    func switchToHorizontalLayout() {
        guard let collectionView = collectionView else { return }
        readMangaVM.changeSlideModeState(state: true)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func switchToVerticalLayout() {
        guard let collectionView = collectionView else { return }
        readMangaVM.changeSlideModeState(state: false)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func configureSlider(){
        slider.minimumValue = 0
        slider.maximumValue = Float(readMangaVM.chapterLength() - 1)
        slider.value = 0
        episodeLabel.text = String("1 / \(readMangaVM.chapterLength())")
        slider.rx.value
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                let currentIndex = Int(value)
                self.episodeLabel.text = String("\(currentIndex + 1) / \(self.readMangaVM.chapterLength())")
                let indexPath = IndexPath(item: currentIndex, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func refreshPopUp(message: String){
        let vc = RefreshPopUp()
        vc.delegate = self
        vc.view.alpha = 0
        vc.errorLabel.text = message
        self.present(vc, animated: false, completion: nil)
        
        UIView.animate(withDuration: 0.5) {
            vc.view.alpha = 1
        }
    }
}

extension ReadMangaViewController: RefreshPopUpDelegate{
    func didTapRefresh() {
        self.dismiss(animated: false)
        loadData()
    }
}
