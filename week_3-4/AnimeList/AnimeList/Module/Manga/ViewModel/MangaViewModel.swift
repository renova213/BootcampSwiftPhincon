import Foundation
import RxSwift
import RxCocoa

class MangaViewModel: BaseViewModel {
    let errorMessage = BehaviorRelay<String>(value: "")
    let userMangaList = BehaviorRelay<[UserMangaEntity]>(value: [])
    let findOneUserManga = BehaviorRelay<UserAnimeEntity?>(value: nil)
    var currentFilterIndex = BehaviorRelay<Int>(value: 4)
    let filterData = ["A-Z", "Z-A", "Score", "Watching Status", "Sort By"]
    
    func loadData <T: Codable>(for endpoint: Endpoint, resultType: T.Type){
        loadingState.accept(.loading)
        loadingState2.accept(.loading)
        
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
                case .deleteUserManga:
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
                case .postUserManga, .deleteUserManga:
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
}
