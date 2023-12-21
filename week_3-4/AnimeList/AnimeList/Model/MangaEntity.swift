import Foundation

struct MangaEntity: Codable{
    let malId: Int
    let title: String?
    let url: String?
    let images: MangaImageType?
    let score: Double?
    let type: String?
    let chapters: Int?
    let status: String?
    let scoredBy: Int?
    let published: Published
    
    enum CodingKeys: String, CodingKey {
        case malId = "mal_id"
        case url = "url"
        case title = "title"
        case images = "images"
        case status = "status"
        case score = "score"
        case type = "type"
        case chapters = "chapters"
        case published = "published"
        case scoredBy = "scored_by"
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
