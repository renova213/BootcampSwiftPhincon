import Foundation

struct UserRecentUpdateEntity: Codable {
    let id: String
    let userId: String
    let userScore: Int
    let watchStatus: Int
    let userEpisode: Int
    let updatedAt: String
    let title: String
    let episode: Int
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, episode, image
        case userId = "user_id"
        case userScore = "user_score"
        case watchStatus = "watch_status"
        case userEpisode = "user_episode"
        case updatedAt = "updated_at"
    }
}
