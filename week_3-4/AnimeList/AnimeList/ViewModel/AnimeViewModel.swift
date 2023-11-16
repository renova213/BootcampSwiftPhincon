import Foundation
import RxSwift
import RxCocoa

class AnimeViewModel {
    static let shared = AnimeViewModel()
    
    let currentAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let currentSeasonAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    let filterAnime = BehaviorRelay<[AnimeEntity]>(value: [])
    
    func getCurrentAnime() {
        let endpoint = Endpoint.getScheduledAnime(params: ScheduleParam(filter: getCurrentDay().lowercased(), page: "1", limit: "6"))
        APIManager.shared.fetchRequest(endpoint: endpoint){[weak self] (result: Result<AnimeData, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.currentAnime.accept(data.data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getCurrentSeasonAnime() {
        
        let endpoint = Endpoint.getSeasonNow(page: "1", limit: "6")
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
    
    func getCurrentDay ()-> String {
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let dayOfWeekString = dateFormatter.string(from: currentDate)
        return dayOfWeekString
    }
    
    func convertTime(from time: String, fromTimeZone: String, to toTimeZone: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let fromTimeZoneObj = TimeZone(identifier: fromTimeZone) {
            dateFormatter.timeZone = fromTimeZoneObj
        } else {
            return nil
        }
        
        guard let sourceDate = dateFormatter.date(from: time) else {
            return nil
        }
        
        if let toTimeZoneObj = TimeZone(identifier: toTimeZone) {
            dateFormatter.timeZone = toTimeZoneObj
        } else {
            return nil
        }
        
        let convertedTime = dateFormatter.string(from: sourceDate)
        
        return convertedTime
    }
}
