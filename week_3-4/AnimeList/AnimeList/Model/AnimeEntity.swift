import Foundation

struct AnimeEntity: Codable{
    let title, type, season, status: String?
    let images: AnimeImageType?
    let score: Double?
    let broadcast: AnimeBroadcast?
    let aired: AnimeAired?
    let malId,scoredBy, rank, year, episodes: Int?
    let genres: [AnimeGenre]
    
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case scoredBy = "scored_by"
        case rank, aired, season, episodes, type, broadcast, score, images, title, year, genres, status
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

struct AnimeGenre: Codable {
    let name: String?
}
