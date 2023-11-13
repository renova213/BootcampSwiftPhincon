import Foundation

struct ScheduleParam{
    var filter: String
    var page: String
    var limit: String
    
    init(filter: String, page: String, limit: String) {
        self.filter = filter
        self.page = page
        self.limit = limit
    }
}

struct SeasonNowParam{
    var page: String
    var limit: String
    
    init(page: String, limit: String) {
        self.page = page
        self.limit = limit
    }
}
