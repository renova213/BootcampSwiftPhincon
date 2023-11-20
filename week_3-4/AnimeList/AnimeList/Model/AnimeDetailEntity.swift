import Foundation

struct AnimeDetailEntity: Codable {
    let data: AnimeDetailData?
}

struct AnimeDetailData: Codable {
    let malID: Int?
    let url: String?
    let images: AnimeDetailImageType?
    let trailer: Trailer?
    let approved: Bool?
    let titles: [Title]?
    let title, titleEnglish, titleJapanese: String?
    let titleSynonyms: [String]?
    let type, source: String?
    let episodes: Int?
    let status: String?
    let airing: Bool?
    let aired: Aired?
    let duration, rating: String?
    let score: Double?
    let scoredBy, rank, popularity, members: Int?
    let favorites: Int?
    let synopsis, background, season: String?
    let year: Int?
    let broadcast: Broadcast?
    let producers, licensors, genres, studios: [AnimeDetailGenre]?
    let themes: [AnimeDetailGenre]?
    let relations: [Relation]?
    let theme: Theme?
    let external, streaming: [External]?
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url, images, trailer, approved, titles, title
        case titleEnglish = "title_english"
        case titleJapanese = "title_japanese"
        case titleSynonyms = "title_synonyms"
        case type, source, episodes, status, airing, aired, duration, rating, score
        case scoredBy
        case rank, popularity, members, favorites, synopsis, background, season, year, broadcast, producers, licensors, studios, genres
        case themes, relations, theme, external, streaming
    }
}

struct AnimeDetailImageType:Codable{
    let jpg: AnimeDetailImage?
}

struct AnimeDetailImage:Codable{
    let imageUrl: String?
    let smallImageUrl: String?
    let largeImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case smallImageUrl = "small_image_url"
        case largeImageUrl = "large_image_url"
    }
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

struct Broadcast: Codable {
    let day, time, timezone, string: String?
}

struct External: Codable {
    let name: String?
    let url: String?
}

struct AnimeDetailGenre: Codable {
    let malID: Int?
    let type, name, url: String?
    
    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case type, name, url
    }
}

enum TypeEnum: String, Codable {
    case anime = "anime"
    case manga = "manga"
}

struct Image: Codable {
    let imageURL, smallImageURL, largeImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case smallImageURL = "small_image_url"
        case largeImageURL = "large_image_url"
    }
}

struct Relation: Codable {
    let relation: String?
    let entry: [AnimeDetailGenre]?
}

struct Theme: Codable {
    let openings, endings: [String]?
}

struct Title: Codable {
    let type, title: String?
}

struct Trailer: Codable {
    let youtubeID: String?
    let url, embedURL: String?
    let images: Images?
    
    enum CodingKeys: String, CodingKey {
        case youtubeID = "youtube_id"
        case url
        case embedURL = "embed_url"
        case images
    }
}

struct Images: Codable {
    let imageURL, smallImageURL, mediumImageURL, largeImageURL: String?
    let maximumImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case smallImageURL = "small_image_url"
        case mediumImageURL = "medium_image_url"
        case largeImageURL = "large_image_url"
        case maximumImageURL = "maximum_image_url"
    }
}
