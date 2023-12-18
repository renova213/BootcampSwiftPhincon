import UIKit
import RxSwift
import RxCocoa

class DetailMangaViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sourceButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        loadData()
        configureGesture()
        configureTableView()
    }
    
    var malId: Int?
    private let disposeBag = DisposeBag()
    private let detailMangaVM = DetailMangaViewModel()
    private var detailManga: DetailMangaEntity? {
        didSet {
            tableView.reloadData()
        }
    }
}

extension DetailMangaViewController {
    func configureGesture(){
        backButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
        favoriteButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
        sourceButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func bindData(){
        detailMangaVM.loadingState.subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading, .notLoad:
                print("Loading")
                break
            case .failed:
                self.refreshPopUp(message: self.detailMangaVM.errorMessage.value)
                break
            case .finished:
                print("Finished")
                break
            }
        }).disposed(by: disposeBag)
        detailMangaVM.mangaDetail.subscribe(onNext: {[weak self] detailManga in
            guard let self = self else { return }
            self.detailManga = detailManga
        }).disposed(by: disposeBag)
    }
    
    func loadData(){
        if let malId = self.malId {
            detailMangaVM.loadData(for: Endpoint.getDetailManga(params:malId ), resultType: DetailMangaResponse.self)
        }
    }
    
    func configureTableView (){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(MangaDetailInfoCell.self)
    }
    
    func refreshPopUp(message: String){
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

extension DetailMangaViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MangaDetailInfoCell
            cell.selectionStyle = .none
            if let detailManga = self.detailManga{
                cell.initialSetup(data: detailManga)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension DetailMangaViewController: RefreshPopUpDelegate {
    func didTapRefresh() {
        loadData()
        self.dismiss(animated: false)
    }
}
