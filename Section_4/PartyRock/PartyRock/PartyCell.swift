//
//  PartyCell.swift
//  PartyRock
//
//  Created by Andrew Huber on 1/16/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

class PartyCell: UITableViewCell {

    @IBOutlet weak var videoPreviewImage: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
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
