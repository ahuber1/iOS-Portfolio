//
//  MyNumberFormatter.swift
//  DreamLister
//
//  Created by Andrew Huber on 1/26/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import Foundation

class MyNumberFormatter: NumberFormatter {
    
    convenience init(withStyle style: NumberFormatter.Style) {
        self.init()
        self.numberStyle = NumberFormatter.Style.currency
    }
    
}
