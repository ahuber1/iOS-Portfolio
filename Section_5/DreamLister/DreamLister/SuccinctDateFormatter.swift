//
//  SuccinctDateFormatter.swift
//  DreamLister
//
//  Created by Andrew Huber on 1/27/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import Foundation

/**
    In Swift, formatting dates and times requires one to make a `DateFormatter` object, set the time and date styles, and then
    call the `string` method. For example:
 
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        let formattedTimeString = formatter.string(from: now)
        print("It is \(formattedTimeString)")
 
    With the `SuccinctDateFormatter`, this becomes
 
        let now = Date()
        let formatter = SuccinctDateFormatter(dateStyle: .long, timeStyle: .long)
        let formattedTimeString = formatter.format(now)
        print("It is \(formattedTimeString)")
 
    or, alternatively, one can do the following:
 
        let now = Date()
        let formattedTimeString = SuccinctDateFormatter.format(now, withDateStyle: .long, andTimeStyle: .long)
        print("It is \(formattedTimeString)")
 
    - note: `SuccinctDateFormatter` has support for both `Date` objects _and_ `NSDate` objects
 */
class SuccinctDateFormatter: DateFormatter {
    
    /**
         Creates a `SuccinctDateFormatter`
         
         - parameters:
            - dateStyle: the date style associated with this `SuccinctDateFormatter`
            - timeStyle: the time style associated with this `SuccinctDateFormatter`
     */
    init(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) {
        super.init()
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
    }
    
    /** **This function is not implemented!!!** */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
         Formats a `Date` object, and returns that `Date` object formatted as a `String`.
         
         - parameters:
            - date: the `Date` object to format.
            - dateStyle: the date style to use when formatting `date`
            - timeStyle: the time style to use when formatting `date`
         
         - returns: `date` formatted as a `String` using the date style `dateStyle` and time style `timeStyle`.
     */
    static func string(from date: Date,
                       withDateStyle dateStyle: DateFormatter.Style,
                       andTimeStyle timeStyle: DateFormatter.Style) -> String
    {
        return SuccinctDateFormatter(dateStyle: dateStyle, timeStyle: timeStyle).string(from: date)
    }
}
