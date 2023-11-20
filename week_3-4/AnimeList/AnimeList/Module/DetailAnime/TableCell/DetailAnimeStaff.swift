import UIKit

class DetailAnimeStaff: UITableViewCell {
    
    @IBOutlet weak var animeStaffCollection: UICollectionView!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    var animeStaffs: [AnimeStaffEntity] = []{
        didSet{
            animeStaffCollection.reloadData()
        }
    }
}

extension DetailAnimeStaff {
    func initialSetup(data: [AnimeStaffEntity]){
        animeStaffs = data
    }
    func configureComponentStyle(){
        moreButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
}

extension DetailAnimeStaff:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func configureCollectionView(){
        animeStaffCollection.delegate = self
        animeStaffCollection.dataSource = self
        animeStaffCollection.registerCellWithNib(AnimeStaffItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animeStaffs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = animeStaffs[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimeStaffItem", for: indexPath)as! AnimeStaffItem
        cell.initialSetup(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = animeStaffs[indexPath.row]
        if let malUrl = data.person?.url{
            if let urlData = URL(string: malUrl) {
                UIApplication.shared.open(urlData, options: [:], completionHandler: nil)
            }
        }
    }
}
