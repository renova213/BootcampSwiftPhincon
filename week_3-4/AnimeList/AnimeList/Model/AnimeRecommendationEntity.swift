import Foundation

struct AnimeRecommendationData: Codable{
    var data: [AnimeRecommendationEntity]
}

struct AnimeRecommendationEntity: Codable {
    let entry: AnimeRecommendationEntry?
    let votes: Int?
}

struct AnimeRecommendationEntry: Codable {
    let malID: Int?
    let url: String?
    let images: AnimeRecommendationImageType?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case malID = "mal_id"
        case url, images, title
    }
}

struct AnimeRecommendationImageType: Codable{
    let jpg: AnimeRecommendationImage?
}

struct AnimeRecommendationImage: Codable {
    let imageURL, smallImageURL, largeImageURL: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case smallImageURL = "small_Image_Url"
        case largeImageURL = "large_image_url"
    }
}
