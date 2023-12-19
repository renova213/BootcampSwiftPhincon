import UIKit
import RxSwift
import RxCocoa

class ReadMangaViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    private let disposeBag = DisposeBag()
    private let readMangaVM = ReadMangaViewModel()
    
    var chapterId: String?
    
    func loadData(){
        if let chapterId = self.chapterId {
            readMangaVM.loadData(for: Endpoint.getMangaChapterImage(params: MangaChapterImageParam(chapterId: chapterId)), resultType: MangaChapterImageResponse.self)
        }
    }
}
