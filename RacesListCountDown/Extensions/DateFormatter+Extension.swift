//
//  DateFormatter+Extension.swift
//  RacesCountDown
//
//  Created by Kohde Pitcher on 19/5/21.
//

import Foundation

extension DateFormatter {
    
    /*
     *  The purpose of this func is to assist in JSON decoding of race times from the REST API
     */
    static let HourMinuteFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        //format - only need hours : minutes AM/PM as thats all that is returned from the API
        formatter.dateFormat = "hh:mma"
        
        //time zone for the formatter - use zero seconds as the time already comes "pre-timezoned"
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        //default date used to construct a date from string if there are missing pieces
        var currentDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
//        print(currentDateComponents.month)
        
        
        formatter.defaultDate = Calendar.current.date(from: currentDateComponents)
        
        return formatter
    }()
    
    //Medium month date formatter
    static let monthMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter
    }()
    
    //Long day name, short day and medium month name
    //Used in the list screen above the large title
    static let monthLongAndShortDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter
    }()
    
    static let dayLongMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }()
}
