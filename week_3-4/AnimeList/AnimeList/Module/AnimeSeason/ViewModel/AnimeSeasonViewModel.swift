import Foundation
import RxSwift
import RxCocoa

class AnimeSeasonViewModel: BaseViewModel {
    
    let titleAppBar = BehaviorRelay<String>(value: "")
    let animeSeasons = BehaviorRelay<[AnimeEntity]>(value: [])
    let seasonList = BehaviorRelay<[SeasonListEntity]>(value: [])
    let selectedSeasonIndex = BehaviorRelay<Int>(value: 0)
    let selectedYearIndex = BehaviorRelay<Int>(value: 0)
    let selectedSeason = BehaviorRelay<String>(value: "")
    let selectedYear = BehaviorRelay<Int>(value: 0)
    let filterIndex = BehaviorRelay<Int>(value: 0)
    
    func loadData <T: Codable>(for endpoint: Endpoint, resultType: T.Type, sortIndex: Int){
        loadingState.accept(.loading)
        
        api.fetchRequest(endpoint: endpoint){ [weak self] (response: Result<T, Error>) in
            guard let self = self else { return }
            switch  response{
            case .success(let data):
                switch endpoint {
                case .getSeason:
                    let data = data as? AnimeSeasonResponse
                    self.animeSeasons.accept(data?.data ?? [])
                    self.sortList(index: sortIndex)
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
    
    func changeTitleAppBar(title: String){
        titleAppBar.accept(title)
    }
    
    func changeSelectedYear(year: Int){
        selectedYear.accept(year)
    }
    
    func changeSelectedSeason(season: String){
        selectedSeason.accept(season)
    }
    
    func changeFilterStatus(index: Int){
        filterIndex.accept(index)
    }
    
    func sortList(index: Int){
        if (index == 1){
            self.animeSeasons.accept(animeSeasons.value.sorted {$0.title ?? "" < $1.title ?? ""})
        }
        if (index == 2){
            self.animeSeasons.accept(animeSeasons.value.sorted {$0.title ?? "" > $1.title ?? ""})
        }
    }
}
