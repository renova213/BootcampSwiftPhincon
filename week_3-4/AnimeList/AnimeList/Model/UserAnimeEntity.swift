import Foundation

struct UserAnimeEntity: Codable {
    let id: String
    let userScore, userEpisode, watchStatus: Int
    let userId: String
    let anime: AnimeEntity
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userScore = "user_score"
        case userEpisode = "user_episode"
        case watchStatus = "watch_status"
        case id, anime
    }
}
