import Foundation

struct ScheduleParam{
    var filter: String
    var limit: String
    
    init(filter: String, limit: String) {
        self.filter = filter
        self.limit = limit
    }
}
