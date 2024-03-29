//
//  DateTime.swift
//  EcoEnergy
//
//  Created by Marcelo De Araújo on 13/02/2024.
//

import Foundation

class DateTime {

    // Convert the date to a string showing the time
    static func formatDateAsTime(date: Date) -> String {
        let timeFormat = "HH:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeFormat // customize the date format here
        return dateFormatter.string(from: date)
    }

    // Convert the date to a string with a month, date and year
    static func formatDateAsUnderscoredString(date: Date) -> String {
        var dateFormatOn: Bool = false
        if let dateFormatStr = UserDefaults.standard.string(forKey: "dateFormatOn") {
            dateFormatOn = !(dateFormatStr == "false")
        }
        var dateFormat = "MM_dd_yyyy"
        if dateFormatOn {
            dateFormat = "dd_MM_yyyy"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat // Customize the date format here
        return dateFormatter.string(from: date)
    }

}
