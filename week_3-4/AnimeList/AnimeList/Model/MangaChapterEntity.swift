import Foundation

struct MangaChaptersEntity: Codable{
    let id: String
    let attributes: MangaChaptersAttributesEntity
}

struct MangaChaptersAttributesEntity: Codable{
    let chapter: String?
    let volume: String?
    let title: String?
    let updatedAt: String?
}
