import Foundation

struct OneUserAnimeParam {
    var userId: String
    var malId: Int
    
    init(userId: String, malId: Int) {
        self.userId = userId
        self.malId = malId
    }
}
