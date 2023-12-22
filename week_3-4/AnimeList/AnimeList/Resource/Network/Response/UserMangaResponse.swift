import Foundation

struct UserMangaResponse: Codable{
    let status: String
    let message: String
    let data: [UserMangaEntity]
}
