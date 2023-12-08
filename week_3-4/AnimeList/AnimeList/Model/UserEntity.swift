import Foundation

struct UserEntity: Codable {
    let id: String
    let username: String
    let email: String
    let birthday: String?
    let urlImage: String
}
