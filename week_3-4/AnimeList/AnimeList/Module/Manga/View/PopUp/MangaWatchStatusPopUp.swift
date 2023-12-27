import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MangaWatchStatusPopUp: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var popUpView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureGesture()
        bindData()
    }
    
    var selectedIndex:Int = 0 {
        didSet{
            tableView.reloadData()
        }
    }
    private let disposeBag = DisposeBag()
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellWithNib(WatchStatusCell.self)
    }
    
    func configureUI(){
        popUpView.roundCornersAll(radius: 24)
    }
    
    func configureGesture(){
        closeButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func bindData(){
        MangaViewModel.shared.selectedSwatchStatusIndex.subscribe(onNext:{[weak self] index in
            guard let self = self else { return }
            self.selectedIndex = index
        }).disposed(by: disposeBag)
    }
}

extension MangaWatchStatusPopUp: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MangaViewModel.shared.watchStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as WatchStatusCell
        let data = MangaViewModel.shared.watchStatus[indexPath.row]
        cell.selectionStyle = .none
        cell.title.text = data
        if (selectedIndex == indexPath.row){
            cell.radioButton.image = UIImage(named: "radio_true")
        }else{
            cell.radioButton.image = UIImage(named: "radio_false")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MangaViewModel.shared.changeSelectedStatusIndex(index: indexPath.row)
    }
}
