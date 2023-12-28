import Foundation
import RxSwift
import RxCocoa

class MangaViewModel: BaseViewModel {
    static let shared = MangaViewModel()

    let userMangaList = BehaviorRelay<[UserMangaEntity]>(value: [])
    let findOneUserManga = BehaviorRelay<UserAnimeEntity?>(value: nil)
    var currentFilterIndex = BehaviorRelay<Int>(value: 4)
    let filterData = ["A-Z", "Z-A", .localized("score"), .localized("readingStatus"), .localized("sortBy")]
    let scoreList:[Int] = [1,2,3,4,5,6,7,8,9,10]
    let watchStatus:[String] = [.localized("reading"), .localized("completed"), .localized("onHold"), .localized("dropped"), .localized("planToRead")]
    var selectedIndexScore = BehaviorRelay<Int>(value: 9)
    var selectedSwatchStatusIndex = BehaviorRelay<Int>(value: 0)
    var episode = BehaviorRelay<Int>(value: 0)
    var messageRating = BehaviorRelay<String>(value: "Pilih rating")
    var selectedStatus = BehaviorRelay<String>(value: "Pilih status")
    
    var showUpdateMangaListBottomSheetRelay = PublishRelay<UserMangaEntity>()
    var increamentMangaChapterRelay = PublishRelay<UpdateUserMangaParam>()
    var deleteUserMAngaRelay = PublishRelay<String>()
    var navigateSearchViewRelay = PublishRelay<Void>()
    var showFilterPopUpRelay = PublishRelay<Void>()
    var reloadDataRelay = PublishRelay<[UserMangaEntity]>()
    
    func loadData <T: Codable>(for endpoint: Endpoint, resultType: T.Type){
        switch endpoint {
        case .getUserManga:
            loadingState.accept(.loading)
        default:
            loadingState2.accept(.loading)
        }
        
        currentFilterIndex.accept(4)
        
        api.fetchRequest(endpoint: endpoint){[weak self] (response: Result<T, Error>) in
            guard let self = self else {return}
            
            switch response {
            case .success(let data):
                switch endpoint {
                case .getUserManga:
                    if let data = data as? UserMangaResponse{
                        self.userMangaList.accept(data.data)
                    }
                    self.loadingState.accept(.finished)
                    break
                case .postUserManga:
                    self.loadingState2.accept(.finished)
                    break
                case .putUserManga:
                    if let data = data as? UserMangaResponse{
                        self.userMangaList.accept(data.data)
                    }
                    self.loadingState2.accept(.finished)
                    break
                case .deleteUserManga:
                    if let data = data as? UserMangaResponse{
                        self.userMangaList.accept(data.data)
                    }
                    self.loadingState2.accept(.finished)
                default:
                    break
                }
                break
            case .failure(let error):
                
                switch endpoint {
                case .getUserManga:
                    if let data = error as? CustomError {
                        if (data.statusCode == HTTPStatusCode.serviceUnvaliable){
                            self.errorMessage.accept(data.message)
                        }else{
                            self.errorMessage.accept("Failed get data")
                        }
                    }
                    self.loadingState.accept(.failed)
                case .postUserManga, .deleteUserManga, .putUserManga:
                    if let data = error as? CustomError {
                        self.errorMessage.accept(data.message)
                    }
                    self.loadingState2.accept(.failed)
                default:
                    break
                }
                break
            }
        }
    }
    
    func sortUserManga(index: Int){
        switch index {
        case 0:
            self.userMangaList.accept(userMangaList.value.sorted {$0.manga.title ?? "" < $1.manga.title ?? ""})
            break
        case 1:
            self.userMangaList.accept(userMangaList.value.sorted {$0.manga.title ?? "" > $1.manga.title ?? ""})
            break
        case 2:
            self.userMangaList.accept(userMangaList.value.sorted {$0.userScore > $1.userScore})
            break
        case 3:
            self.userMangaList.accept(userMangaList.value.sorted {$0.watchStatus < $1.watchStatus})
        default:
            break
        }
    }
    
    func changeCurrentFilterIndex(index: Int){
        currentFilterIndex.accept(index)
    }
    
    func changeSelectedStatusIndex(index: Int){
        selectedSwatchStatusIndex.accept(index)
        changeTitleWatchStatus()
    }
    
    func changeSelectedIndexScore(index: Int){
        selectedIndexScore.accept(index)
        changeMessageRating()
    }
    
    func resetBottomSheet(){
        changeSelectedIndexScore(index: 9)
        episode.accept(0)
        changeSelectedStatusIndex(index: 0)
    }
    
    func setupBottomSheet(data: UserAnimeEntity){
        changeSelectedIndexScore(index: data.userScore - 1)
        selectedSwatchStatusIndex.accept(data.watchStatus)
        episode.accept(data.userEpisode)
        changeMessageRating()
        changeTitleWatchStatus()
        
    }
    
    func decreamentEpisode(){
        if (episode.value > 0){
            episode.accept(episode.value - 1)
        }
    }
    
    func increamentEpisode(totalEpisode: Int){
        if (episode.value < totalEpisode){
            episode.accept(episode.value + 1)
        }
    }
    
    func changeTitleWatchStatus(){
        switch selectedSwatchStatusIndex.value{
        case 0:
            selectedStatus.accept(.localized("watching"))
        case 1:
            selectedStatus.accept(.localized("completed"))
        case 2:
            selectedStatus.accept(.localized("onHold"))
        case 3:
            selectedStatus.accept(.localized("dropped"))
        case 4:
            selectedStatus.accept(.localized("planToRead"))
        default:
            selectedStatus.accept(.localized("selectStatus"))
        }
    }
    
    func changeMessageRating(){
        switch selectedIndexScore.value{
        case 0:
            messageRating.accept(.localized("1"))
            break
        case 1:
            messageRating.accept(.localized("2"))
            break
        case 2:
            messageRating.accept(.localized("3"))
            break
        case 3:
            messageRating.accept(.localized("4"))
            break
        case 4:
            messageRating.accept(.localized("5"))
            break
        case 5:
            messageRating.accept(.localized("6"))
            break
        case 6:
            messageRating.accept(.localized("7"))
            break
        case 7:
            messageRating.accept(.localized("8"))
            break
        case 8:
            messageRating.accept(.localized("9"))
            break
        case 9:
            messageRating.accept(.localized("10"))
            break
        default:
            messageRating.accept(.localized("selectRating"))
        }
    }
}
