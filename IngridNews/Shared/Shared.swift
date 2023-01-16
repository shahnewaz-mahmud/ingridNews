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
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: date)

        let hour = timeComponents.hour!
        let minute = timeComponents.minute!
        let second = timeComponents.second!

        dateFormatter.dateFormat = "h:mm:ss a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"

        let time = dateFormatter.string(from: date)
        let readableDate = "\(dateComponents.year!)-\(dateComponents.month!)-\(dateComponents.day!)"
        
        return (time,readableDate)
        
        
    }
}
