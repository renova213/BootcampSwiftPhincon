import Foundation

struct MangaMangadexResponse: Codable {
    let result: String
    let data: [MangaMangadexEntity]
}
