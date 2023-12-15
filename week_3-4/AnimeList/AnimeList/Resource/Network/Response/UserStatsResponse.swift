import Foundation

struct UserStatsResponse: Codable {
    let data: UserStatsEntity
    let status: String
    let message: String
}
