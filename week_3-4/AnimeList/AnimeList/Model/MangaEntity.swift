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
    let genres: [MangaGenre]
    
    enum CodingKeys: String, CodingKey {
        case genres, url, title, images, status, score, type, chapters, published
        case malId = "mal_id"
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

struct MangaGenre: Codable {
    let name: String?
}
