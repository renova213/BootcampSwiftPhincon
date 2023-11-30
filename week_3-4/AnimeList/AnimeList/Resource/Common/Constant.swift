import Foundation
import UIKit

struct BaseConstant{
    static let baseURL = "https://api.jikan.moe/v4"
    static let baseURL2 = "http://fine-plum-fossa.cyclic.app"
    static let userDefaults = UserDefaults.standard
}

enum SFSymbol {
    static let homeSymbol = UIImage(systemName: "homekit")
    static let animeSymbol = UIImage(systemName: "film")
    static let mangaSymbol = UIImage(systemName: "chart.bar.doc.horizontal")
    static let otherSymbol = UIImage(systemName: "line.horizontal.3")
}

enum TopAnimeEnum {
    case airing
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

