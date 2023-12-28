import Foundation

extension Date {
    static func getCurrentDay() -> String {
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let dayOfWeekString = dateFormatter.string(from: currentDate)
        return dayOfWeekString
    }
    
    static func getCurrentYear() -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        return year
    }
    
    static func currentSeason(in timeZone: TimeZone) -> String {
        var calendar = Calendar.current
        calendar.timeZone = timeZone
        
        let components = calendar.dateComponents([.month], from: Date())
        
        guard let month = components.month else {
            return "Unknown Season"
        }
        
        let season: Season
        switch month {
        case 3...5:
            season = .spring
        case 6...8:
            season = .summer
        case 9...11:
            season = .autumn
        default:
            season = .winter
        }
        
        return season.rawValue
    }
}
