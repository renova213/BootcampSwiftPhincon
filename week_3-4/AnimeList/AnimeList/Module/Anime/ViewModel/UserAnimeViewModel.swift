import Foundation
import RxSwift
import RxCocoa

class UserAnimeViewModel {
    static let shared = UserAnimeViewModel()
    
    var userAnime = BehaviorRelay<[UserAnimeEntity]>(value: [])
    let findOneUserAnime = BehaviorRelay<UserAnimeEntity?>(value: nil)
    var currentFilterIndex = BehaviorRelay<Int>(value: 4)
    let filterData = ["A-Z", "Z-A", "Score", "Watching Status", "Sort By"]
    
    func postUserAnime(body: UserAnimeParam, completion: @escaping((Result<StatusResponse, Error>)-> Void)) {
        let endpoint = Endpoint.postUserAnime(params: body)
        APIManager.shared.fetchRequest(endpoint: endpoint){(result: Result<StatusResponse, Error>) in
            completion(result)
        }
    }
    
    func getUserAnime(userId: String, completion: @escaping((Bool)-> Void)) {
        let endpoint = Endpoint.getUserAnime(params: userId)
        APIManager.shared.fetchRequest(endpoint: endpoint){(result: Result<UserAnimeResponse, Error>) in
            switch result {
            case .success(let data):
                self.userAnime.accept(data.data)
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func updateUserAnime(body: UpdateUserAnimeParam, completion: @escaping((Result<StatusResponse, Error>)-> Void)) {
        let endpoint = Endpoint.putUserAnime(params: body)
        APIManager.shared.fetchRequest(endpoint: endpoint){(result: Result<StatusResponse, Error>) in
           completion(result)
        }
    }
    
    func deleteUserAnime(id: String, completion: @escaping((Result<StatusResponse, Error>)-> Void)) {
        let endpoint = Endpoint.deleteUserAnime(params: id)
        APIManager.shared.fetchRequest(endpoint: endpoint){(result: Result<StatusResponse, Error>) in
           completion(result)
        }
    }
    
    func findOneUserAnime(userId: String, malId: Int, completion: @escaping((Bool)-> Void)) {
        let endpoint = Endpoint.findOneUserAnime(params: OneUserAnimeParam(userId: userId, malId: malId))
        APIManager.shared.fetchRequest(endpoint: endpoint){(result: Result<FindOneUserAnimeResponse, Error>) in
            switch result {
            case .success(let data):
                if let userAnimeData = data.data{
                    self.findOneUserAnime.accept(userAnimeData)
                }
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func sortUserAnime(index: Int){
        switch index {
        case 0:
            self.userAnime.accept(userAnime.value.sorted {$0.anime.title ?? "" < $1.anime.title ?? ""})
        break
        case 1:
            self.userAnime.accept(userAnime.value.sorted {$0.anime.title ?? "" > $1.anime.title ?? ""})
        case 2:
            self.userAnime.accept(userAnime.value.sorted {$0.userScore > $1.userScore})
        case 3:
            self.userAnime.accept(userAnime.value.sorted {$0.watchStatus < $1.watchStatus})
        default:
            break
        }
    }
    
    func changeCurrentFilterIndex(index: Int){
        currentFilterIndex.accept(index)
    }
}
