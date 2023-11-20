//
//  DateFormatter.swift
//  AnimeList
//
//  Created by Phincon on 20/11/23.
//

import Foundation

extension DateFormatter {
    static func customFormattedString(from inputDateString: String, inputFormat: String, outputFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        
        if let inputDate = dateFormatter.date(from: inputDateString) {
            dateFormatter.dateFormat = outputFormat
            let outputDateString = dateFormatter.string(from: inputDate)
            return outputDateString
        } else {
            return nil
        }
    }
    
    static func convertTime(from time: String, fromTimeZone: String, to toTimeZone: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let fromTimeZoneObj = TimeZone(identifier: fromTimeZone) {
            dateFormatter.timeZone = fromTimeZoneObj
        } else {
            return nil
        }
        
        guard let sourceDate = dateFormatter.date(from: time) else {
            return nil
        }
        
        if let toTimeZoneObj = TimeZone(identifier: toTimeZone) {
            dateFormatter.timeZone = toTimeZoneObj
        } else {
            return nil
        }
        
        let convertedTime = dateFormatter.string(from: sourceDate)
        
        return convertedTime
    }
}
