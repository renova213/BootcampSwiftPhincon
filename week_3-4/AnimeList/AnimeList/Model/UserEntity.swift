import Foundation

struct UserEntity: Codable {
    let id: String
    let username: String
    let email: String
    let birthday: String
    let image: UserImage
    let joinedDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "username"
        case email = "email"
        case image = "image"
        case birthday = "birthday"
        case joinedDate = "joined_date"
    }
}

struct UserImage: Codable {
    let urlImage: String
    let filePath: String
    let fileType: String
}
