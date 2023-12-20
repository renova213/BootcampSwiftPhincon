import UIKit
import RxSwift
import RxCocoa
import SkeletonView

protocol MangaChapterCellDelegate: AnyObject {
    func didTapSortChapter()
    func didTapNavigateReadChapter(chapterId: String, title: String)
}

class MangaChapterCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
        configureGesture()
    }
    
    var mangaChapters: [MangaChaptersEntity] = []{
        didSet{
            tableView.reloadData()
        }
    }
    
    private let disposeBag = DisposeBag()
    private let detailMangaVM = DetailMangaViewModel()
    weak var delegate: MangaChapterCellDelegate?
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCellWithNib(MangaChapterItemCell.self)
    }
    
    func configureGesture(){
        sortButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            
            self.delegate?.didTapSortChapter()
        }).disposed(by: disposeBag)
    }
}

extension MangaChapterCell: SkeletonTableViewDelegate, UITableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return String(describing: MangaChapterItemCell.self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangaChapters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = mangaChapters[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as MangaChapterItemCell
        cell.initialSetup(data: data)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = mangaChapters[indexPath.row]
        self.delegate?.didTapNavigateReadChapter(chapterId: data.id, title: data.attributes.title ?? "-")
    }
}
