import Foundation

struct AnimeStaffData: Codable {
    var data: [AnimeStaffEntity]
}

struct AnimeStaffEntity: Codable {
    let person: AnimeStaffPerson?
    let positions: [String]?
}

struct AnimeStaffPerson: Codable {
    let malID: Int?
    let url: String?
    let images: AnimeStaffImages?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case malID = "mall_id"
        case url, images, name
    }
}

struct AnimeStaffImages: Codable {
    let jpg: Jpg?
}

struct AnimeStaffImagesJpg: Codable {
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
    }
}
