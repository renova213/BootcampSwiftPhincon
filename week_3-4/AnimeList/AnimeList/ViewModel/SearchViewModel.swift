import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    static let shared = SearchViewModel()
    
    let filteredAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let filteredManga = BehaviorRelay<[MangaEntity]>(value: [])
    let currentIndex = BehaviorRelay<Int>(value: 0)
    let searchCategoryItem: [String] = ["Anime", "Manga"]
    
    func getFilterAnime(filterParam: FilterAnimeParam, completion: @escaping(Bool) -> Void) {
        let endpoint = Endpoint.filterAnime(params: filterParam)
        let query = filterParam.q ?? ""
        if(query != ""){
            APIManager.shared.fetchRequest(endpoint: endpoint){[weak self] (result: Result<AnimeData, Error>) in
                guard let self = self else { return }
                    switch result {
                    case .success(let data):
                        self.filteredAnime.accept(data.data)
                        completion(true)
                    case .failure:
                        completion(false)
                    }
                }
        }else {
            self.filteredAnime.accept([])
        }
    }
    
    func getFilterManga(filterParam: FilterMangaParam, completion: @escaping(Bool) -> Void) {
        let endpoint = Endpoint.filterManga(params: filterParam)
        let query = filterParam.q ?? ""
        
        if(query != ""){
            APIManager.shared.fetchRequest(endpoint: endpoint){[weak self] (result: Result<MangaData, Error>) in
                guard let self = self else { return }
                    switch result {
                    case .success(let data):
                        self.filteredManga.accept(data.data)
                        completion(true)
                    case .failure:
                        completion(false)
                    }
                }
        }else {
            self.filteredManga.accept([])
        }
    }
    
    func changeCurrentIndex(index: Int){
        self.currentIndex.accept(index)
    }
}
