import Foundation

struct FindOneUserAnimeResponse: Codable{
    let status: String
    let message: String
    let data: UserAnimeEntity?
}
