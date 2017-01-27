//
//  ItemCell.swift
//  DreamLister
//
//  Created by Andrew Huber on 1/25/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var date: UILabel!
    
    func configureCell(withItem item: Item) {
        title.text = item.title
        price.text = item.formattedPriceString
        details.text = item.details
        date.text = item.formattedCreatedString
        thumbnail.image = item.toImage?.image as? UIImage
    }
}
