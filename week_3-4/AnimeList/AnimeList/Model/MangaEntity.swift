import Foundation

struct MangaEntity: Codable{
    var malId: Int?
    var title: String?
    var images: MangaImageType?
    var score: Double?
    var type: String?
    var chapters: Int?
    var status: String?
    var published: Published
    
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case title = "title"
        case images = "images"
        case status = "status"
        case score = "score"
        case type = "type"
        case chapters = "chapters"
        case published = "published"
    }
}

struct MangaImageType:Codable{
    var jpg: AnimeImage?
}

struct MangaImage:Codable{
    var imageUrl: String?
    var smallImageUrl: String?
    var largeImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case smallImageUrl = "small_image_url"
        case largeImageUrl = "large_image_url"
    }
}

struct Published: Codable{
    var prop: Prop
    var string: String?
}
