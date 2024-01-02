import Foundation
import RxSwift
import RxCocoa

class FavoriteViewModel {
    static let shared = FavoriteViewModel()
    
    let isExistAnimeFavorite = BehaviorRelay<Bool>(value: false)
    let isExistAnimeCharacter = BehaviorRelay<Bool>(value: false)
    let isExistAnimeCast = BehaviorRelay<Bool>(value: false)
    
    func isExistFavoriteList(for favorite: FavoriteEnum) {
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
        case .animeCharacter(let animeCharacter):
            guard let characterName = animeCharacter.character?.name, let malId = animeCharacter.character?.malID else {
                print("Character name or malId is nil")
                return
            }
            
            let isExist = CoreDataHelper.shared.isFavoriteEntityExist(FavoriteAnimeCharacterEntity.self, userId: userId, predicateFormat: "userId == %@ AND malId == %d AND name == %@",args: userId, malId, characterName)
            isExistAnimeCharacter.accept(isExist)
            break
        case .animeCast(let animeCharacter):
            guard let castName = animeCharacter.voiceActors?.first?.person?.name, let malId = animeCharacter.voiceActors?.first?.person?.malID else {
                print("Cast name or malId is nil")
                return
            }
            let isExist = CoreDataHelper.shared.isFavoriteEntityExist(FavoriteAnimeCastEntity.self, userId: userId, predicateFormat: "userId == %@ AND malId == %d AND name == %@",args: userId, malId, castName)
            isExistAnimeCast.accept(isExist)
            break
        case .manga(let manga):
            guard let mangaTitle = manga.title else {
                print("Manga title is nil")
                return
            }
            
            let isExist = CoreDataHelper.shared.isFavoriteEntityExist(FavoriteMangaEntity.self, userId: userId, predicateFormat: "userId == %@ AND malId == %d AND title == %@", args: userId, manga.malID, mangaTitle )
            isExistAnimeFavorite.accept(isExist)
            break
        }
    }
    
    func deleteFavoriteList(for favorite: FavoriteEnum, userId: String) {
        switch favorite {
        case .anime(let anime):
            guard let title = anime.title else {return}
            
            CoreDataHelper.shared.deleteFavoriteEntity(FavoriteAnimeEntity.self, predicateFormat: "title == %@ AND userId == %@",args: title, userId)
            isExistFavoriteList(for: favorite)
            break
        case .animeCharacter(let animeCharacter):
            guard let name = animeCharacter.character?.name else {return}
            
            CoreDataHelper.shared.deleteFavoriteEntity(FavoriteAnimeCharacterEntity.self, predicateFormat: "name == %@ AND userId == %@", args: name, userId)
            isExistFavoriteList(for: favorite)
            break
        case .animeCast(let animeCharacter):
            guard let name = animeCharacter.voiceActors?.first?.person?.name else {return}
            
            CoreDataHelper.shared.deleteFavoriteEntity(FavoriteAnimeCastEntity.self, predicateFormat: "name == %@, AND userId == %@", args: name, userId)
            isExistFavoriteList(for: favorite)
            break
        case .manga(let manga):
            guard let title = manga.title else {return}
            
            CoreDataHelper.shared.deleteFavoriteEntity(FavoriteMangaEntity.self, predicateFormat: "title == %@ AND userId == %@",args: title, userId)
            isExistFavoriteList(for: favorite)
            break
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
            isExistFavoriteList(for: favorite)
            break
        case .animeCharacter(let animeCharacter):
            guard let characterName = animeCharacter.character?.name, let characterMalId = animeCharacter.character?.malID else {return }
            
            let properties: [String: Any] = [
                "name": characterName,
                "url": animeCharacter.character?.url ?? "",
                "urlImage": animeCharacter.character?.images?.jpg?.imageURL ?? "",
                "malId": Int32(characterMalId)
            ]
            
            CoreDataHelper.shared.addOrUpdateFavoriteEntity(FavoriteAnimeCharacterEntity.self, for: favorite, userId: userId, properties: properties)
            isExistFavoriteList(for: favorite)
            break
        case .animeCast(let animeCharacter):
            guard let castMalId = animeCharacter.voiceActors?.first?.person?.malID else {return }
            
            let properties: [String: Any] = [
                "name": animeCharacter.voiceActors?.first?.person?.name ?? "",
                "url": animeCharacter.voiceActors?.first?.person?.url ?? "",
                "urlImage": animeCharacter.voiceActors?.first?.person?.images?.jpg?.imageURL ?? "",
                "malId": Int32(castMalId)
            ]
            
            CoreDataHelper.shared.addOrUpdateFavoriteEntity(FavoriteAnimeCastEntity.self, for: favorite, userId: userId, properties: properties)
            isExistFavoriteList(for: favorite)
            break
        case .manga(let manga):
            guard let title = manga.title else {return}
            
            let properties: [String: Any] = [
                "title": title,
                "urlImage": manga.images?.jpg?.imageURL ?? "",
                "url": manga.url ?? "",
                "malId": Int32(manga.malID)
            ]
            
            CoreDataHelper.shared.addOrUpdateFavoriteEntity(FavoriteMangaEntity.self, for: favorite, userId: userId, properties: properties)
            isExistFavoriteList(for: favorite)
            break
        }
    }
}
