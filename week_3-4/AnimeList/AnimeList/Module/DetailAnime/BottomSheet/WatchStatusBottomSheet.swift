import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class WatchStatusBottomSheet: UIViewController {
    
    @IBOutlet weak var urlImage: UIImageView!
    @IBOutlet weak var statusTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        configureUI()
        bindViewModel()
    }
    
    var imageUrl: String?
    var selectedIndex:Int = 0 {
        didSet{
            statusTable.reloadData()
        }
    }
    func setContentHeight(_ height: CGFloat) {
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func configureUI(){
        view.roundCornersAll(radius: 24)
        if let url = URL(string: imageUrl ?? ""){
            urlImage.kf.setImage(with: url, placeholder: UIImage(named: "ImagePlaceholder"))
        }
    }
}

extension WatchStatusBottomSheet: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailAnimeViewModel.shared.watchStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = DetailAnimeViewModel.shared.watchStatus[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as WatchStatusItem
        cell.selectionStyle = .none
        cell.titleLabel.text = data
        if (selectedIndex == indexPath.row){
            cell.radioImage.image = UIImage(named: "radio_true")
        }else{
            cell.radioImage.image = UIImage(named: "radio_false")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DetailAnimeViewModel.shared.changeSelectedStatusIndex(index: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureTable(){
        statusTable.dataSource = self
        statusTable.delegate = self
        statusTable.registerCellWithNib(WatchStatusItem.self)
    }
    
    func bindViewModel(){
        DetailAnimeViewModel.shared.selectedSwatchStatusIndex.subscribe(onNext: {i in
            self.selectedIndex = i
        }).disposed(by: DisposeBag())
    }
}
