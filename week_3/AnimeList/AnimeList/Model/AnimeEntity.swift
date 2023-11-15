import Foundation

struct AnimeData: Codable {
    var data: [AnimeEntity]
}

struct AnimeEntity: Codable{
    var malId: Int?
    var title:String?
    var images: AnimeImageType?
    var score: Double?
    var broadcast: AnimeBroadcast?
    var type: String?
    var episodes: Int?
    var season: String?
    var aired: Aired?
    var status: String?
    
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
    }
}

struct AnimeImageType:Codable{
    var jpg: AnimeImage?
}

struct AnimeImage:Codable{
    var imageUrl: String?
    var smallImageUrl: String?
    var largeImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case smallImageUrl = "small_image_url"
        case largeImageUrl = "large_image_url"
    }
}

struct AnimeBroadcast:Codable{
    var day: String?
    var time: String?
    var timezone: String?
    var dateTime: String?
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
