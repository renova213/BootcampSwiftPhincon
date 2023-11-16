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
    let aired: Aired?
    let status: String?
    let synopsis: String?
    let rank: Int?
    let popularity: Int?
    let members: Int?
    let favorite: Int?
    let url: String?
    let duration: String?
    let trailer: AnimeTrailer
    
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
        case status = "status"
        case synopsis = "synopsis"
        case rank = "rank"
        case popularity = "popularity"
        case members = "members"
        case favorite = "favorite"
        case url = "url"
        case duration = "duration"
        case trailer = "trailer"
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

struct Aired: Codable {
    let from: String?
    let to: String?
    let prop: Prop?
    let string: String?
}

struct Prop: Codable {
    let from, to: From?
}

struct From: Codable {
    let day, month, year: Int?
}

struct AnimeTrailer: Codable {
    let youtubeId: String?
    let url: String?
    let embedUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case youtubeId = "youtube_id"
        case url = "url"
        case embedUrl = "embed_url"
    }
}
