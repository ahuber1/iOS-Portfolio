//
//  PartyCell.swift
//  PartyRock
//
//  Created by Andrew Huber on 1/16/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

/**
    The table view cell for the main screen of the Party Rock app.
 
    - author: Andrew Huber
 
 */
class PartyCell: UITableViewCell {

    /** An image view displaying the preview of the music video. */
    @IBOutlet weak var videoPreviewImage: UIImageView!
    
    /** A label displaying the title of the music video. */
    @IBOutlet weak var videoTitleLabel: UILabel!
    
    /**
     Updates the contents of this `PartyCell` with the information stored
     in a `VideoInformation` object.
     
     - parameters:
        - info: the `VideoInformation` object
     */
    func updateUI(withInfo info: VideoInformation) {
        videoTitleLabel.text = info.videoTitle
        
        let url = URL(string: info.imageURL)!
        
        DispatchQueue.global().async { // Asyncrhonous thread
            do {
                
                let data = try Data(contentsOf: url) // downloads image
                
                DispatchQueue.global().sync { // UI thread
                    self.videoPreviewImage.image = UIImage(data: data)
                }
            } catch {
                NSLog("Downloading image for \(info.videoTitle) failed...")
                self.videoPreviewImage.image = UIImage()
            }
        }
    }
}
