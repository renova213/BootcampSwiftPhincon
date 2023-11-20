import Foundation

struct AnimeData: Codable {
    var data: [AnimeEntity]
}

struct AnimeEntity: Codable{
    let malId: Int?
    let title:String?
    let images: AnimeImageType?
    let score: Double?
    let broadcast: AnimeBroadcast?
    let type: String?
    let episodes: Int?
    let season: String?
    let aired: AnimeAired?
    let rank: Int?
    
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case title = "title"
        case images = "images"
        case score = "score"
        case broadcast = "broadcast"
        case type = "type"
        case episodes = "episodes"
        case season = "season"
        case aired = "aired"
        case rank = "rank"
    }
}

struct AnimeImageType:Codable{
    let jpg: AnimeImage?
}

struct AnimeImage:Codable{
    let imageUrl: String?
    let smallImageUrl: String?
    let largeImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case smallImageUrl = "small_image_url"
        case largeImageUrl = "large_image_url"
    }
}

struct AnimeBroadcast:Codable{
    let day: String?
    let time: String?
    let timezone: String?
    let dateTime: String?
}

struct AnimeAired: Codable {
    let from: String?
    let to: String?
    let prop: AnimeProp?
    let string: String?
}

struct AnimeProp: Codable {
    let from, to: AnimeFrom?
}

struct AnimeFrom: Codable {
    let day, month, year: Int?
}
