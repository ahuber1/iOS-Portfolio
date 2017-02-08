//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Andrew Huber on 1/24/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import Foundation
import CoreData

fileprivate let numberFormatter = SuccinctNumberFormatter(withStyle: .currency)
fileprivate let dateFormatter = SuccinctDateFormatter(dateStyle: .short, timeStyle: .short)

@objc(Item)
public class Item: NSManagedObject {
    
    // When an Item is created, we set its created property to the current date and time
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        // Set the created property to the current date and time
        self.created = NSDate()
    }
    
    /** A `String` representation of the `price` property */
    public var priceString: String { return "\(self.price)" }
    
    /** A `String` representation of the `price` property, but formatted using the currency style. 
     For example, if `price` was `1993.99`, this would be `"$1,993.99"`. */
    public var formattedPriceString: String { return numberFormatter.string(for: self.price)! }
    
    /** A `String` representation of the `created` property, but formatted using the short style for
     both dates and times, which will generate a `String` like `"2/1/17, 10:40 AM"` **/
    public var formattedCreatedString: String { return dateFormatter.string(for: self.created!)! }
}
