import Foundation

struct MangaChapterImageResponse: Codable{
    let result: String
    let baseUrl: String
    let chapter: MangaChapterImageEntity
}
