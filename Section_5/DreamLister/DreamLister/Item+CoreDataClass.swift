//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Andrew Huber on 1/24/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import Foundation
import CoreData

fileprivate let numberFormatter = MyNumberFormatter(withStyle: .currency)
fileprivate let dateFormatter = MyDateFormatter(dateStyle: .short, timeStyle: .short)

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
    }
    
    public var priceString: String { return "\(self.price)" }
    public var formattedPriceString: String { return numberFormatter.string(for: self.price)! }
    public var formattedCreatedString: String { return dateFormatter.format(self.created!) }
}
