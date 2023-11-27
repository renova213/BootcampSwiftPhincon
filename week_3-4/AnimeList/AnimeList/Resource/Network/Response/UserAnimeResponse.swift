import Foundation

struct UserAnimeResponse: Codable{
    let status: String
    let message: String
    let data: [UserAnimeEntity]?
}
