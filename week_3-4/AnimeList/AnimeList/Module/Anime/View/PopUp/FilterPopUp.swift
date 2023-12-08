import UIKit
import RxSwift
import RxCocoa

protocol FilterPopUpDelegate: AnyObject {
    func didTapFilterIndex(index: Int)
}

class FilterPopUp: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindData()
        configureTableView()
        configureGesture()
    }
    
    weak var delegate: FilterPopUpDelegate?
    private let animeVM = UserAnimeViewModel()
    private let disposeBag = DisposeBag()
    var currentIndex = 5{
        didSet{
            tableView.reloadData()
        }
    }
    
    func initialIndex(index: Int){
        currentIndex = index
    }
    
    func configureGesture(){
        okButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false)
            self.delegate?.didTapFilterIndex(index: self.currentIndex)
        }).disposed(by: disposeBag)
        cancelButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: false)
        }).disposed(by: disposeBag)
        
    }
    
    func bindData(){
        animeVM.currentFilterIndex.asObservable().subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            
            self.currentIndex = index
        }).disposed(by: disposeBag)
    }
    
    func configureUI(){
        popUpView.roundCornersAll(radius: 10)
        popUpView.addShadow()
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(FilterPopUpTableCell.self)
    }
}

extension FilterPopUp: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        animeVM.filterData.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filterData = animeVM.filterData[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as FilterPopUpTableCell
        cell.initialSetup(title: filterData, index: indexPath.row, currentIndex: currentIndex)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animeVM.changeCurrentFilterIndex(index: indexPath.row)
    }
}
