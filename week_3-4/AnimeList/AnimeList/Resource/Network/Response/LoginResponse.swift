import Foundation

struct LoginResponse: Codable {
    let status: String
    let message: String
    let user: UserEntity?
    let token: String?
}
