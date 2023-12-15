import Foundation

struct UserStatsEntity: Codable {
    let watching: Int
    let drop: Int
    let completed: Int
    let shows: Int
    let episodes: Int
    let onHold: Int
    let planToWatch: Int
    let averageRating: Double
    
    enum CodingKeys: String, CodingKey {
        case watching, drop, shows, episodes, completed
        case onHold = "on_hold"
        case planToWatch = "plan_to_watch"
        case averageRating = "average_rating"
    }
}
