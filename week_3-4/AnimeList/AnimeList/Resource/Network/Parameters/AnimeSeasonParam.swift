import Foundation

struct AnimeSeasonParam {
    let page: Int
    let limit: Int
    let year: Int
    let season: String
    
    init(page: Int = 1, limit: Int = 15, year: Int, season: String) {
        self.page = page
        self.limit = limit
        self.year = year
        self.season = season
    }
}
