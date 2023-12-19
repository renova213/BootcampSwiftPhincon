import Foundation

struct MangaChaptersResponse: Codable {
    let result: String
    let data: [MangaChaptersEntity]
}
