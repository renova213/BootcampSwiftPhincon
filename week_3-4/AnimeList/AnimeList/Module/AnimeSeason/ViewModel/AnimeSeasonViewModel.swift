import Foundation
import RxSwift
import RxCocoa

class AnimeSeasonViewModel: BaseViewModel {
    let api = APIManager.shared
    
    let animeSeasons = BehaviorRelay<[AnimeEntity]>(value: [])
    
    func loadData <T: Codable>(for endpoint: Endpoint, resultType: T.Type){
        loadingState.accept(.loading)
        
        api.fetchRequest(endpoint: endpoint){ [weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            switch  response{
            case .success(let data):
                let data = data as? AnimeResponse
                self.animeSeasons.accept(data?.data ?? [])
                self.loadingState.accept(.finished)
                break
            case .failure:
                self.loadingState.accept(.failed)
            }
        }
    }
}
