import Foundation
import UIKit

struct BaseConstant{
    static let baseURL = "https://api.jikan.moe/v4"
    static let baseURL2 = "http://fine-plum-fossa.cyclic.app"
    static let baseURL3 = "https://api.mangadex.org"
    static let userDefaults = UserDefaults.standard
}

enum SFSymbol {
    static let homeSymbol = UIImage(systemName: "homekit")
    static let animeSymbol = UIImage(systemName: "film")
    static let mangaSymbol = UIImage(systemName: "chart.bar.doc.horizontal")
    static let profileSymbol = UIImage(systemName: "person.fill")
}

enum TopAnimeEnum {
    case airing
    case upcoming
    case popularity
    case favorite
}

enum TopMangaEnum {
    case publishing
    case upcoming
    case popularity
    case favorite
}

enum AnimeCalendarEnum {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case unknown
    case other
}

enum Season: String {
    case spring, summer, autumn, winter
}

enum ValidationResult {
    case success
    case failure(CustomError)
}

enum StateLoading: Int {
    case initial
    case loading
    case finished
    case failed
    case empty
}

enum FavoriteEnum {
    case anime(entity: AnimeDetailEntity)
    case animeCharacter(entity: AnimeCharacterEntity)
    case animeCast(entity: AnimeCharacterEntity)
    case manga(entity: DetailMangaEntity)
}

enum FetchFavoriteEnum {
    case anime
    case animeCharacter
    case animeCast
    case manga
}
