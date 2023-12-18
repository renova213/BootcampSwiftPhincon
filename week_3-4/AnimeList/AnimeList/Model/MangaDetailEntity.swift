import Foundation

struct DetailMangaEntity: Codable {
    let malID: Int
    let url, title, titleEnglish, titleJapanese, type, synopsis, status: String?
    let images: DetailMangaImage?
    let approved, publishing: Bool?
    let chapters, volumes, scoredBy, rank, popularity, members, favorites: Int?
    let published: Published?
    let score, scored: Double?
    let genres: [DetailMangaGenre]?

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case titleEnglish = "title_english"
        case titleJapanese = "title_japanese"
        case scoredBy = "scored_by"
        case url, title, type, synopsis, status, images, approved, publishing, chapters, volumes, rank, popularity, members, favorites, published, score, scored, genres
    }
}

struct DetailMangaGenre: Codable {
    let name: String
}

struct DetailMangaImage: Codable {
    let jpg: DetailMangaImageItem?
}

struct DetailMangaImageItem: Codable {
    let imageURL, smallImageURL, largeImageURL: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case smallImageURL = "small_image_url"
        case largeImageURL = "large_image_url"
    }
}

struct DetailMangaPublished: Codable {
    let from, to: Date?
    let prop: DetailMangaProp?
    let string: String?
}

struct DetailMangaProp: Codable {
    let from, to: DetailMangaFrom?
}

struct DetailMangaFrom: Codable {
    let day, month, year: Int?
}
