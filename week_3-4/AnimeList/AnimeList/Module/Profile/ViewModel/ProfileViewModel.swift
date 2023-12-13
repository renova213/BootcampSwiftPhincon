import Foundation
import RxSwift
import RxCocoa
import Kingfisher
import CoreData

class ProfileViewModel: BaseViewModel {
    
    var favoriteAnimeList = BehaviorRelay<[FavoriteAnimeEntity]>(value: [])
    var favoriteAnimeCharacterList = BehaviorRelay<[FavoriteAnimeCharacterEntity]>(value: [])
    let userData = BehaviorRelay<UserEntity?>(value: nil)
    var errorMessage = BehaviorRelay<CustomError?>(value: nil)
    
    func multipartData <T: Codable>(for endpoint: Endpoint, image: Data, resultType: T.Type){
        api.fetchMultipartRequest(endpoint: endpoint, image: image){ [weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            switch response{
            case .success:
                switch endpoint {
                case .postUploadProfileImage:
                    if let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults(){
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
    
    func updateData <T: Codable>(for endpoint: Endpoint, resultType: T.Type){
        loadingState.accept(.loading)
        
        api.fetchRequest(endpoint: endpoint){ [weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            switch response{
            case .success:
                switch endpoint {
                case .putUser:
                    self.loadingState.accept(.finished)
                    break
                case .putChangePassword:
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
    
    func fetchFavoriteList(for favorite: FetchFavoriteEnum) {
        do {
            if let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults() {
                switch favorite {
                case .anime:
                    let favoriteAnimeList: [FavoriteAnimeEntity] = try CoreDataHelper.shared.fetchFavoriteList( FavoriteAnimeEntity.self, userId: userId)
                    self.favoriteAnimeList.accept(favoriteAnimeList)
                    break
                case .character:
                    let favoriteAnimeCharacter: [FavoriteAnimeCharacterEntity] = try CoreDataHelper.shared.fetchFavoriteList(FavoriteAnimeCharacterEntity.self, userId: userId)
                    self.favoriteAnimeCharacterList.accept(favoriteAnimeCharacter)
                }
            }
        } catch {
            print("Error fetching favorite data: \(error)")
        }
    }
    
    func clearImageCache() {
        KingfisherManager.shared.cache.clearDiskCache()
    }
}
