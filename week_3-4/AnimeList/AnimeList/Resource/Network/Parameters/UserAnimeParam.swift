import Foundation

struct UserAnimeParam: Codable{
    let userId: Int
    let malId: Int
    let userScore: Int
    let userEpisode: Int
    let watchStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case malId = "mal_id"
        case userScore = "user_score"
        case userEpisode = "user_episode"
        case watchStatus = "watch_status"
    }
}
