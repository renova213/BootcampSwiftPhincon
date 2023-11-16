//
//  ExtCurrency.swift
//  fuel_management_app
//
//  Created by Phincon on 03/11/23.
//

import Foundation

extension Int {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) {
            return formattedNumber
        }
        return ""
    }
}
