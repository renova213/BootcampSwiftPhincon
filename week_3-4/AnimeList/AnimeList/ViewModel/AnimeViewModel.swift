import Foundation
import RxSwift
import RxCocoa

class AnimeViewModel: BaseViewModel {
    static let shared = AnimeViewModel()
    let api = APIManager.shared
    
    let showMoreAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let currentAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let currentSeasonAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let filterAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let animeCharacter = BehaviorRelay<[AnimeCharacterEntity]>(value: [])
    let animeStaff = BehaviorRelay<[AnimeStaffEntity]>(value: [])
    let animeRecommendations = BehaviorRelay<[AnimeRecommendationEntity]>(value: [])
    
    func loadData <T: Codable>(for endpoint: Endpoint, resultType: T.Type){
        loadingState.accept(.loading)
        
        api.fetchRequest(endpoint: endpoint){ [weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            
            switch  response{
            case .success(let data):
                switch endpoint {
                case .getScheduledAnime:
                    let data = data as? AnimeResponse
                    self.currentAnime.accept(data?.data ?? [])
                    self.loadingState.accept(.finished)
                    break
                case .getSeasonNow:
                    let data = data as? AnimeResponse
                    self.currentSeasonAnime.accept(data?.data ?? [])
                    self.loadingState.accept(.finished)
                    break
                case .getAnimeCharacter:
                    let data = data as? AnimeCharacterResponse
                    if let character = data?.data{
                        self.animeCharacter.accept(character)
                    }
                    self.loadingState.accept(.finished)
                    break
                case .getRecommendationAnime:
                    let data = data as? AnimeRecommendationResponse
                    self.animeRecommendations.accept(data?.data ?? [])
                    self.loadingState.accept(.finished)
                    break
                default:
                    self.loadingState.accept(.finished)
                    break
                }
            case .failure:
                self.loadingState.accept(.failed)
                break
            }
        }
    }
    
    func getShowMoreAnime(endpoint: Endpoint, completion: @escaping(Bool)-> Void) {
        
        APIManager.shared.fetchRequest(endpoint: endpoint){[weak self] (result: Result<AnimeResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.showMoreAnime.accept(data.data)
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func getAnimeCharacter(malId: Int) {
        
        APIManager.shared.fetchRequest(endpoint: Endpoint.getAnimeCharacter(malId: malId)){[weak self] (result: Result<AnimeCharacterResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.animeCharacter.accept(data.data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getAnimeStaff(malId: Int) {
        
        APIManager.shared.fetchRequest(endpoint: Endpoint.getAnimeStaff(malId: malId)){[weak self] (result: Result<AnimeStaffResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.animeStaff.accept(data.data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getAnimeRecommendations(malId: Int) {
        APIManager.shared.fetchRequest(endpoint: Endpoint.getRecommendationAnime(malId: malId)){[weak self] (result: Result<AnimeRecommendationResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.animeRecommendations.accept(data.data)
            case .failure(let err):
                print(err)
            }
        }
    }
}
