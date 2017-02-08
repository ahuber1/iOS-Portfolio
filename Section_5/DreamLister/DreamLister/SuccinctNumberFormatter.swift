//
//  MyNumberFormatter.swift
//  DreamLister
//
//  Created by Andrew Huber on 1/26/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import Foundation

/**
     In Swift, formatting numbers requires one to make a `NumberFormatter` object, set the number style, and then
     call the `string` method. For example:
     
        let price = 49.99
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let formattedPrice = formatter.string(from: price)!
        print("The price of the item is \(formattedPrice)")
     
     With the `SuccinctNumberFormatter`, this becomes
     
         let price = 49.99
         let formatter = SuccinctNumberFormatter(withStyle: .currency)
         let formattedPrice = formatter.string(from: price)!
         print("The price of the item is \(formattedPrice)")
 
     or, alternatively, one can do the following:
     
         let price = 49.99
         let formattedPrice = SuccincyNumberFormatter.string(from: price, withStyle: .currency)!
         print("The price of the item is \(formattedPrice)")
 */
class SuccinctNumberFormatter: NumberFormatter {
    
    /**
        Creates a `SuccinctNumberFormatter`
     
        - parameters:
            - style: the number style
     */
    convenience init(withStyle style: NumberFormatter.Style) {
        self.init()
        self.numberStyle = style
    }
    
    /**
         Formats a number with a style, and returns that formatted number as a `String`
         
         - parameters:
            - number: the number to format
            - style: the number style that dictates how `number` should be formatted
         
         - returns: `number` that is formatted according to `style`, or `nil` if `number` 
                    could not be formatted according to `style`
     */
    static func string(from number: NSNumber, withStyle style: NumberFormatter.Style) -> String? {
        return SuccinctNumberFormatter(withStyle: style).string(from: number)
    }
}
