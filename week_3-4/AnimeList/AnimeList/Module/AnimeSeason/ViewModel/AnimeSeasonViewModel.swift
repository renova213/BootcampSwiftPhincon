import Foundation
import RxSwift
import RxCocoa

class AnimeSeasonViewModel: BaseViewModel {
    
    let animeSeasons = BehaviorRelay<[AnimeEntity]>(value: [])
    let seasonList = BehaviorRelay<[SeasonListEntity]>(value: [])
    let selectedSeasonIndex = BehaviorRelay<Int>(value: 0)
    let selectedYearIndex = BehaviorRelay<Int>(value: 0)
    let filterIndex = BehaviorRelay<Int>(value: 0)
    
    func loadData <T: Codable>(for endpoint: Endpoint, resultType: T.Type, index: Int){
        loadingState.accept(.loading)
        
        api.fetchRequest(endpoint: endpoint){ [weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            switch  response{
            case .success(let data):
                switch endpoint {
                case .getSeasonNow:
                    let data = data as? AnimeResponse
                    self.animeSeasons.accept(data?.data ?? [])
                    self.sortList(index: index)
                    self.loadingState.accept(.finished)
                case .getSeasonList:
                    let data = data as? SeasonListResponse
                    self.seasonList.accept(data?.data ?? [])
                    self.loadingState.accept(.finished)
                default:
                    break
                }
                break
            case .failure:
                self.loadingState.accept(.failed)
            }
        }
    }
    
    func changeSelectedSeasonIndex(index: Int){
        selectedSeasonIndex.accept(index)
    }
    
    func changeSelectedYearIndex(index: Int){
        selectedYearIndex.accept(index)
    }
    
    func changeFilterStatus(index: Int){
        filterIndex.accept(index)
    }
    
    func sortList(index: Int){
        if (index == 1){
            self.animeSeasons.accept(animeSeasons.value.sorted {$0.title ?? "" < $1.title ?? ""})
        }
        if (index == 2){
            print(self.animeSeasons.value)
            self.animeSeasons.accept(animeSeasons.value.sorted {$0.title ?? "" > $1.title ?? ""})
        }
    }
}
