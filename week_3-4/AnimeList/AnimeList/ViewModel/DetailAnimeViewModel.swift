import Foundation
import RxSwift
import RxCocoa

class DetailAnimeViewModel {
    static let shared = DetailAnimeViewModel()
    
    let scoreList:[Int] = [1,2,3,4,5,6,7,8,9,10]
    let watchStatus:[String] = ["Watching", "Completed", "On Hold", "Dropped", "Plan to Watch"]
    var selectedIndexScore = BehaviorRelay<Int>(value: 10)
    var selectedSwatchStatusIndex = BehaviorRelay<Int>(value: 0)
    var episode = BehaviorRelay<Int>(value: 0)
    var messageRating = BehaviorRelay<String>(value: "Pilih rating")
    var selectedStatus = BehaviorRelay<String>(value: "Pilih status")
    
    func changeSelectedIndexScore(index: Int){
        selectedIndexScore.accept(index)
    }
    
    func changeSelectedStatusIndex(index: Int){
        selectedSwatchStatusIndex.accept(index)
    }
    
    func decreamentEpisode(){
        if (episode.value > 0){
            episode.accept(episode.value - 1)
        }
    }
    
    func increamentEpisode(totalEpisode: Int){
        if (episode.value < totalEpisode){
            episode.accept(episode.value + 1)
        }
    }
    
    func selectWatchStatus(status: String){
        selectedStatus.accept(status)
    }
    
    func changeMessageRating(){
        switch selectedIndexScore.value{
        case 1:
            messageRating.accept("Sangat Mengerikan")
            break
        case 2:
            messageRating.accept("Mengerikan")
            break
        case 3:
            messageRating.accept("Sangat Buruk")
            break
        case 4:
            messageRating.accept("Buruk")
            break
        case 5:
            messageRating.accept("Rata-rata")
            break
        case 6:
            messageRating.accept("Baik")
            break
        case 7:
            messageRating.accept("Bagus")
            break
        case 8:
            messageRating.accept("Sangat Baik")
            break
        case 9:
            messageRating.accept("Hebat")
            break
        case 10:
            messageRating.accept("Karya Terbaik")
            break
        default:
            messageRating.accept("Pilih rating")
        }
    }
}
