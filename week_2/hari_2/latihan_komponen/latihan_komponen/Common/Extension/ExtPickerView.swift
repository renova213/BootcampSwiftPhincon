//
//  ExtPickerView.swift
//  latihan_komponen
//
//  Created by Phincon on 31/10/23.
//

import Foundation
import UIKit

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { // Hours
            return 12
        } else if component == 1 { // Minutes
            return 60
        } else { // AM/PM
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 { // Hours
            return "\(row + 1)"
        } else if component == 1 { // Minutes
            return String(format: "%02d", row)
        } else { // AM/PM
            return (row == 0) ? "AM" : "PM"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHour = pickerView.selectedRow(inComponent: 0) + 1
        let selectedMinute = pickerView.selectedRow(inComponent: 1)
        let amPm = (pickerView.selectedRow(inComponent: 2) == 0) ? "AM" : "PM"
        
        pickerLabel.text = String(format: "%02d:%02d %@", selectedHour, selectedMinute, amPm)
    }
}
