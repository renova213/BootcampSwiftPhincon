import Foundation
import CoreData
import RxSwift
import RxCocoa

class DetailAnimeViewModel: BaseViewModel {
    static let shared = DetailAnimeViewModel()
    
    let scoreList:[Int] = [1,2,3,4,5,6,7,8,9,10]
    let watchStatus:[String] = ["Watching", "Completed", "On Hold", "Dropped", "Plan to Watch"]
    var selectedIndexScore = BehaviorRelay<Int>(value: 9)
    var selectedSwatchStatusIndex = BehaviorRelay<Int>(value: 0)
    var episode = BehaviorRelay<Int>(value: 0)
    var messageRating = BehaviorRelay<String>(value: "Pilih rating")
    var selectedStatus = BehaviorRelay<String>(value: "Pilih status")
    let animeDetail = BehaviorRelay<AnimeDetailEntity?>(value: nil)
    let animeCharacter = BehaviorRelay<[AnimeCharacterEntity]>(value: [])
    let animeStaff = BehaviorRelay<[AnimeStaffEntity]>(value: [])
    let animeRecommendations = BehaviorRelay<[AnimeRecommendationEntity]>(value: [])
    let isExistAnimeFavorite = BehaviorRelay<Bool>(value: false)
    let isExistAnimeCharacter = BehaviorRelay<Bool>(value: false)
    let isExistAnimeCast = BehaviorRelay<Bool>(value: false)
    
    
    func getDetailAnime(malId: Int, completion: @escaping(Bool) -> Void) {
        
        APIManager.shared.fetchRequest(endpoint: Endpoint.getDetailAnime(params: malId)){[weak self] (result: Result<AnimeDetailResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.animeDetail.accept(data.data)
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func getAnimeCharacter(malId: Int) {
        
        APIManager.shared.fetchRequest(endpoint: Endpoint.getAnimeCharacter(params: malId)){[weak self] (result: Result<AnimeCharacterResponse, Error>) in
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
        
        APIManager.shared.fetchRequest(endpoint: Endpoint.getAnimeStaff(params: malId)){[weak self] (result: Result<AnimeStaffResponse, Error>) in
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
        APIManager.shared.fetchRequest(endpoint: Endpoint.getRecommendationAnime(params: malId)){[weak self] (result: Result<AnimeRecommendationResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.animeRecommendations.accept(data.data)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    
    func isExistFavoriteAnimeList(for favorite: FavoriteEnum) {
        guard let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults() else {
            print("User ID is nil")
            return
        }

        switch favorite {
        case .anime(let anime):
            guard let animeTitle = anime.title else {
                print("Anime title is nil")
                return
            }

            let isExist = CoreDataHelper.shared.isFavoriteEntityExist(FavoriteAnimeEntity.self, userId: userId, predicateFormat: "userId == %@ AND malId == %d AND title == %@", args: userId, anime.malID, animeTitle)
            isExistAnimeFavorite.accept(isExist)
            break
        case .character(let animeCharacter):
            guard let characterName = animeCharacter.character?.name, let malId = animeCharacter.character?.malID else {
                print("Character name or malId is nil")
                return
            }

            let isExist = CoreDataHelper.shared.isFavoriteEntityExist(FavoriteAnimeCharacterEntity.self, userId: userId, predicateFormat: "userId == %@ AND malId == %d AND name == %@",args: userId, malId, characterName)
            isExistAnimeCharacter.accept(isExist)
            break
        case .cast(let animeCharacter):
            guard let castName = animeCharacter.voiceActors?.first?.person?.name, let malId = animeCharacter.voiceActors?.first?.person?.malID else {
                print("Cast name or malId is nil")
                return
            }
            let isExist = CoreDataHelper.shared.isFavoriteEntityExist(FavoriteAnimeCastEntity.self, userId: userId, predicateFormat: "userId == %@ AND malId == %d AND name == %@",args: userId, malId, castName)
            isExistAnimeCast.accept(isExist)
        }
    }
    
    func deleteFavoriteAnimeList(for favorite: FavoriteEnum) {
        switch favorite {
        case .anime(let anime):
            guard let title = anime.title else {return}

            CoreDataHelper.shared.deleteFavoriteEntity(FavoriteAnimeEntity.self, predicateFormat: "title == %@",args: title)
            isExistFavoriteAnimeList(for: favorite)

        case .character(let animeCharacter):
            guard let name = animeCharacter.character?.name else {return}

            CoreDataHelper.shared.deleteFavoriteEntity(FavoriteAnimeCharacterEntity.self, predicateFormat: "name == %@", args: name)
            isExistFavoriteAnimeList(for: favorite)
        case .cast(let animeCharacter):
            guard let name = animeCharacter.voiceActors?.first?.person?.name else {return}

            CoreDataHelper.shared.deleteFavoriteEntity(FavoriteAnimeCastEntity.self, predicateFormat: "name == %@", args: name)
            isExistFavoriteAnimeList(for: favorite)
        }
    }
    
    func addToFavorite(for favorite: FavoriteEnum) {
        guard let userId = UserDefaultHelper.shared.getUserIDFromUserDefaults() else {return
        }

        switch favorite {
        case .anime(let anime):
            guard let title = anime.title else {return}

            let properties: [String: Any] = [
                "title": title,
                "urlImage": anime.images?.jpg?.imageUrl ?? "",
                "url": anime.url ?? "",
                "malId": Int32(anime.malID)
            ]

            CoreDataHelper.shared.addOrUpdateFavoriteEntity(FavoriteAnimeEntity.self, for: favorite, userId: userId, properties: properties)
            isExistFavoriteAnimeList(for: favorite)
            break
        case .character(let animeCharacter):
            guard let characterName = animeCharacter.character?.name, let characterMalId = animeCharacter.character?.malID else {return }

            let properties: [String: Any] = [
                "name": characterName,
                "url": animeCharacter.character?.url ?? "",
                "urlImage": animeCharacter.character?.images?.jpg?.imageURL ?? "",
                "malId": Int32(characterMalId)
            ]

            CoreDataHelper.shared.addOrUpdateFavoriteEntity(FavoriteAnimeCharacterEntity.self, for: favorite, userId: userId, properties: properties)
            isExistFavoriteAnimeList(for: favorite)
            break
        case .cast(let animeCharacter):
            guard let castMalId = animeCharacter.voiceActors?.first?.person?.malID else {return }

            let properties: [String: Any] = [
                "name": animeCharacter.voiceActors?.first?.person?.name ?? "",
                "url": animeCharacter.voiceActors?.first?.person?.url ?? "",
                "urlImage": animeCharacter.voiceActors?.first?.person?.images?.jpg?.imageURL ?? "",
                "malId": Int32(castMalId)
            ]

            CoreDataHelper.shared.addOrUpdateFavoriteEntity(FavoriteAnimeCastEntity.self, for: favorite, userId: userId, properties: properties)
            isExistFavoriteAnimeList(for: favorite)
            break
        }
    }
    
    func changeSelectedStatusIndex(index: Int){
        selectedSwatchStatusIndex.accept(index)
        changeTitleWatchStatus()
    }
    
    func changeSelectedIndexScore(index: Int){
        selectedIndexScore.accept(index)
        changeMessageRating()
    }
    
    func resetBottomSheet(){
        changeSelectedIndexScore(index: 9)
        episode.accept(0)
        changeSelectedStatusIndex(index: 0)
    }
    
    func setupBottomSheet(data: UserAnimeEntity){
        changeSelectedIndexScore(index: data.userScore - 1)
        selectedSwatchStatusIndex.accept(data.watchStatus)
        episode.accept(data.userEpisode)
        changeMessageRating()
        changeTitleWatchStatus()
        
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
    
    func changeTitleWatchStatus(){
        switch selectedSwatchStatusIndex.value{
        case 0:
            selectedStatus.accept("Watching")
        case 1:
            selectedStatus.accept("Completed")
        case 2:
            selectedStatus.accept("On Hold")
        case 3:
            selectedStatus.accept("Dropped")
        case 4:
            selectedStatus.accept("Plan to Watch")
        default:
            selectedStatus.accept("Select status")
        }
    }
    
    func changeMessageRating(){
        switch selectedIndexScore.value{
        case 0:
            messageRating.accept("Sangat Mengerikan")
            break
        case 1:
            messageRating.accept("Mengerikan")
            break
        case 2:
            messageRating.accept("Sangat Buruk")
            break
        case 3:
            messageRating.accept("Buruk")
            break
        case 4:
            messageRating.accept("Rata-rata")
            break
        case 5:
            messageRating.accept("Baik")
            break
        case 6:
            messageRating.accept("Bagus")
            break
        case 7:
            messageRating.accept("Sangat Baik")
            break
        case 8:
            messageRating.accept("Hebat")
            break
        case 9:
            messageRating.accept("Karya Terbaik")
            break
        default:
            messageRating.accept("Pilih rating")
        }
    }
}
