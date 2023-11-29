import Foundation

struct SeasonNowParam{
    var page: String
    var limit: String
    
    init(page: String, limit: String) {
        self.page = page
        self.limit = limit
    }
}
