import Foundation

struct TopAnimeParam {
    var filter: String
    var page: Int
    
    init(filter: String, page: Int) {
        self.filter = filter
        self.page = page
    }
}
