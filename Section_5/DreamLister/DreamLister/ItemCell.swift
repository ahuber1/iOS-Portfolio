//
//  ItemCell.swift
//  DreamLister
//
//  Created by Andrew Huber on 1/25/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

/**
    This class contains the code for the table cells that are displayed in the main
    screen of the DreamLister app.
 */
class ItemCell: UITableViewCell {

    /** The thumbnail of the item that the user wants */
    @IBOutlet weak var thumbnail: UIImageView!
    
    /** The title of the item that the user wants */
    @IBOutlet weak var title: UILabel!
    
    /** The price of the item that the user wants */
    @IBOutlet weak var price: UILabel!
    
    /** A description of the item that the user wants */
    @IBOutlet weak var details: UILabel!
    
    /** The date and time the item that the user wants was created */
    @IBOutlet weak var date: UILabel!
    
    /**
         Sets the contents of this `ItemCell` based on the contents of an `Item` object
         (i.e., based on the item that the user wants)
         
         - parameters:
            - item: the `Item` object
     */
    func configureCell(withItem item: Item) {
        title.text = item.title
        price.text = item.formattedPriceString
        details.text = item.details
        date.text = item.formattedCreatedString
        thumbnail.image = item.toImage?.image as? UIImage
    }
}
