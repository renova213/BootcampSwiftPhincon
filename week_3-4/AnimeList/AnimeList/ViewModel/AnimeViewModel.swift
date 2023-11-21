import Foundation
import RxSwift
import RxCocoa

class AnimeViewModel {
    static let shared = AnimeViewModel()
    
    let showMoreAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let currentAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let currentSeasonAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let filterAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let animeDetail = BehaviorRelay<AnimeDetailData?>(value: nil)
    let animeCharacter = BehaviorRelay<[AnimeCharacterEntity]>(value: [])
    let animeStaff = BehaviorRelay<[AnimeStaffEntity]>(value: [])
    let animeRecommendations = BehaviorRelay<[AnimeRecommendationEntity]>(value: [])
    
    func getCurrentAnime(limit: String, page: String, completion: @escaping(Bool) -> Void) {
        let endpoint = Endpoint.getScheduledAnime(params: ScheduleParam(filter: Date.getCurrentDay().lowercased(), page: page, limit: limit))
        APIManager.shared.fetchRequest(endpoint: endpoint){[weak self] (result: Result<AnimeData, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.currentAnime.accept(data.data)
                    completion(true)
                }
            case .failure:
                completion(false)
            }
        }
    }
    
    func getCurrentSeasonAnime(limit: String, page: String) {
        
        let endpoint = Endpoint.getSeasonNow(page: page, limit: limit)
        APIManager.shared.fetchRequest(endpoint: endpoint){[weak self] (result: Result<AnimeData, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.currentSeasonAnime.accept(data.data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getShowMoreAnime(endpoint: Endpoint, completion: @escaping(Bool)-> Void) {
        
        APIManager.shared.fetchRequest(endpoint: endpoint){[weak self] (result: Result<AnimeData, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.showMoreAnime.accept(data.data)
                    completion(true)
                }
            case .failure:
                completion(false)
            }
        }
    }
    
    func getDetailAnime(malId: Int, completion: @escaping(Bool) -> Void) {
        
        APIManager.shared.fetchRequest(endpoint: Endpoint.getDetailAnime(malId: malId)){[weak self] (result: Result<AnimeDetailEntity, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                switch result {
                case .success(let data):
                    self.animeDetail.accept(data.data)
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
        }
    }
    
    func getAnimeCharacter(malId: Int) {
        
        APIManager.shared.fetchRequest(endpoint: Endpoint.getAnimeCharacter(malId: malId)){[weak self] (result: Result<AnimeCharacterData, Error>) in
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
        
        APIManager.shared.fetchRequest(endpoint: Endpoint.getAnimeStaff(malId: malId)){[weak self] (result: Result<AnimeStaffData, Error>) in
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
        APIManager.shared.fetchRequest(endpoint: Endpoint.getRecommendationAnime(malId: malId)){[weak self] (result: Result<AnimeRecommendationData, Error>) in
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
