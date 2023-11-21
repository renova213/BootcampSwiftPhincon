import UIKit
import RxSwift
import RxCocoa

class RankAnimeViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filterCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonGesture()
    }
    
    private var disposeBag = DisposeBag()
    private var listFilter: [String] = [
    "Skor", "Popularitas", "Favorit", "Mendatang"]
}

extension RankAnimeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension RankAnimeViewController{
    private func backButtonGesture(){
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        ).disposed(by: disposeBag)
    }
}
