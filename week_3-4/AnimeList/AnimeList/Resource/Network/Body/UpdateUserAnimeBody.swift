import Foundation

struct UpdateUserAnimeBody: Codable{
    let id: String
    let userScore: Int
    let userEpisode: Int
    let watchStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userScore = "user_score"
        case userEpisode = "user_episode"
        case watchStatus = "watch_status"
    }
}
