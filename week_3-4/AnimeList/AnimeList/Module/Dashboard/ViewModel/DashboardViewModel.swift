import Foundation
import RxSwift
import RxCocoa

class DashboardViewModel: BaseViewModel {
    static let shared = DashboardViewModel()
    
    let currentAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let currentSeasonAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    
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
                default:
                    self.loadingState.accept(.finished)
                    break
                }
                break
            case .failure:
                self.loadingState.accept(.failed)
            }
        }
    }
}
