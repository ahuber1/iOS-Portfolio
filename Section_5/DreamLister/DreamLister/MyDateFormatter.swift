//
//  MyDateFormatter.swift
//  DreamLister
//
//  Created by Andrew Huber on 1/27/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import Foundation

class MyDateFormatter {
    
    var dateStyle: DateFormatter.Style {
        get {
            return formatter.dateStyle
        }
        set {
            formatter.dateStyle = newValue
        }
    }
    
    var timeStyle: DateFormatter.Style {
        get {
            return formatter.timeStyle
        }
        set {
            formatter.timeStyle = newValue
        }
    }
    
    private let formatter = DateFormatter()
    
    init(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) {
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
    }
    
    func format(_ date: Date) -> String {
        return formatter.string(from: date)
    }
    
    func format(_ nsDate: NSDate) -> String {
        return format(nsDate as Date)
    }
}
