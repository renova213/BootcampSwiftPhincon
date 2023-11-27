import Foundation

struct UserAnimeEntity: Codable {
    let id: String
    let userId, userScore, userEpisode, watchStatus: Int
    let anime: AnimeEntity
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userScore = "user_score"
        case userEpisode = "user_episode"
        case watchStatus = "watch_status"
        case id, anime
    }
}
