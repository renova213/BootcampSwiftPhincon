import Foundation
import RxSwift
import RxCocoa
import Alamofire
import CoreData

class ProfileViewModel: BaseViewModel {
    let userData = BehaviorRelay<UserEntity?>(value: nil)
    var errorMessage = BehaviorRelay<CustomError?>(value: nil)
    var favoriteAnimeList = BehaviorRelay<[FavoriteAnimeEntity]>(value: [])
    
    func multipartData <T: Codable>(for endpoint: Endpoint, image: Data, resultType: T.Type){
        api.fetchMultipartRequest(endpoint: endpoint, image: image){ [weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            switch response{
            case .success:
                switch endpoint {
                case .postUploadProfileImage:
                    if let userId = self.tokenHelper.getUserIDFromUserDefaults(){
                        self.loadData(for: Endpoint.getUser(params: userId), resultType: UserResponse.self)
                        self.loadingState.accept(.finished)
                    }
                    break
                default:
                    self.loadingState.accept(.finished)
                    break
                }
                break
            case .failure(let error):
                if let error = error as? CustomError {
                    self.errorMessage.accept(error)
                }
                self.loadingState.accept(.failed)
            }
        }
    }
    
    func loadData <T: Codable>(for endpoint: Endpoint, resultType: T.Type){
        loadingState.accept(.loading)
        
        api.fetchRequest(endpoint: endpoint){ [weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            switch response{
            case .success(let data):
                switch endpoint {
                case .getUser:
                    if let data = data as? UserResponse{
                        self.userData.accept(data.data)
                        self.loadingState.accept(.finished)
                    }
                    break
                case .putUser:
                    self.loadingState.accept(.finished)
                    break
                default:
                    self.loadingState.accept(.finished)
                    break
                }
                break
            case .failure(let error):
                if let error = error as? CustomError {
                    self.errorMessage.accept(error)
                }
                self.loadingState.accept(.failed)
            }
        }
    }
    
    func clearAlamofireCache() {
        if let cache = Alamofire.Session.default.sessionConfiguration.urlCache {
            cache.removeAllCachedResponses()
        }
    }
    
    func fetchFavoriteAnimeList(){        
        do {
            let fetchRequest: NSFetchRequest<FavoriteAnimeEntity> = FavoriteAnimeEntity.fetchRequest()
            let favoriteAnimeList = try context.fetch(fetchRequest)
            self.favoriteAnimeList.accept(favoriteAnimeList)
        } catch {
            print("Error fetching favorite anime data: \(error)")
        }
    }
}
