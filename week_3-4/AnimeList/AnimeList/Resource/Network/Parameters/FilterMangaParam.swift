import Foundation

struct FilterMangaParam {
    var page: String?
    var limit: String?
    var q: String?
    
    init(page: String? = nil, limit: String? = nil, q: String? = nil) {
        self.page = page
        self.limit = limit
        self.q = q
    }
}
