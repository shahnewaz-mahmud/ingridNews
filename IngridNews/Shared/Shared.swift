//
//  Shared.swift
//  IngridNews
//
//  Created by Shahnewaz on 14/1/23.
//

import Foundation

class Shared{
    
    func getReadableDataTime(data: String) -> (String,String)
    {
        let dateString = data
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format")
            return ("","")
        }

        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        dateFormatter.dateFormat = "h:mm:ss a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"

        let time = dateFormatter.string(from: date)
        let readableDate = "\(dateComponents.year!)-\(dateComponents.month!)-\(dateComponents.day!)"
        
        return (time,readableDate)
        
        
    }
}


extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
