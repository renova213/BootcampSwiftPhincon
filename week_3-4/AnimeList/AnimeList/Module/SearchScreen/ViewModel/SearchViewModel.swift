import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: BaseViewModel {
    static let shared = SearchViewModel()
    let api = APIManager.shared

    let filteredAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let filteredManga = BehaviorRelay<[MangaEntity]>(value: [])
    let currentIndex = BehaviorRelay<Int>(value: 0)
    let searchCategoryItem: [String] = ["Anime", "Manga"]
    
    func loadData <T: Codable>(for endpoint: Endpoint, resultType: T.Type){
        loadingState.accept(.loading)
        
        api.fetchRequest(endpoint: endpoint){ [weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            
            switch  response{
            case .success(let data):
                switch endpoint {
                case .filterAnime:
                    let data = data as? AnimeResponse
                    self.filteredAnime.accept(data?.data ?? [])
                    self.loadingState.accept(.finished)
                    break
                case .filterManga:
                    let data = data as? MangaResponse
                    self.filteredManga.accept(data?.data ?? [])
                    self.loadingState.accept(.finished)
                    break
                default:
                    break
                }
                break
            case .failure:
                self.loadingState.accept(.failed)
            }
        }
    }
    
    func changeCurrentIndex(index: Int){
        self.currentIndex.accept(index)
    }
}
