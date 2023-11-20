import Foundation

extension Date {
    static func getCurrentDay() -> String {
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let dayOfWeekString = dateFormatter.string(from: currentDate)
        return dayOfWeekString
    }
}
