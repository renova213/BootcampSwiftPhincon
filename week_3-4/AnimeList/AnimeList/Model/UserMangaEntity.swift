import Foundation

struct UserMangaEntity: Codable {
    let id, userId, mangaId: String
    let userScore, userEpisode, watchStatus: Int
    let chapters: [String]
    let manga: MangaEntity
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userScore = "user_score"
        case userEpisode = "user_episode"
        case watchStatus = "watch_status"
        case mangaId = "manga_id"
        case id, manga, chapters
    }
}
    
