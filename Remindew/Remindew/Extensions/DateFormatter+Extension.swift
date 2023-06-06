//
//  DateFormatter+Extension.swift
//  Remindew
//
//  Created by Лена Гусарова on 01.06.2023.
//

import Foundation

extension DateFormatter {
    
    
    static let navBarDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM/d"
        return formatter
    }()
    
   
    static let lastWateredDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM/dd/yy, h:mm a"
        return formatter
    }()
    
  
    static let timeOnlyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
 
    static let dateOnlyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
   
    static let shortTimeAndDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
   
    static func returnDateFromHourAndMinute(hour: Int, minute: Int) -> Date {
        
        let currentDayComps = Calendar.current.dateComponents([.calendar, .timeZone, .era, .year, .month, .day,
                                                               .hour, .minute, .second, .nanosecond, .weekday, .weekdayOrdinal,
                                                               .quarter, .weekOfMonth, .weekOfYear, .yearForWeekOfYear], from: Date())
        
        let newDateComps = DateComponents(calendar: currentDayComps.calendar,
                                          timeZone: currentDayComps.timeZone,
                                          era: currentDayComps.era,
                                          year: currentDayComps.year,
                                          month: currentDayComps.month,
                                          day: currentDayComps.day,
                                          hour: hour,
                                          minute: minute,
                                          second: currentDayComps.second,
                                          nanosecond: currentDayComps.nanosecond,
                                          weekday: currentDayComps.weekday,
                                          weekdayOrdinal: currentDayComps.weekdayOrdinal,
                                          quarter: currentDayComps.quarter,
                                          weekOfMonth: currentDayComps.weekOfMonth,
                                          weekOfYear: currentDayComps.weekOfYear,
                                          yearForWeekOfYear: currentDayComps.yearForWeekOfYear)
        
        return Calendar.current.date(from: newDateComps)!
    }
}
