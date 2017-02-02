//
//  VideoVC.swift
//  PartyRock
//
//  Created by Andrew Huber on 1/16/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

/**
    The view controller for the screen that displays the music video.
 
    - author: Andrew Huber
 */
class VideoVC: UIViewController {
    
    /** The web view that will display the music video */
    @IBOutlet weak var webView: UIWebView!
    
    /** A label displaying the song title */
    @IBOutlet weak var songTitleLabel: UILabel!
    
    /** A `VideoInformation` object representing all the information regarding the video that is currently being displayed. */
    var videoInformation: VideoInformation!

    // Sets up the view controller's views
    override func viewDidLoad() {
        super.viewDidLoad()

        songTitleLabel.text = videoInformation.videoTitle
        
        webView.loadHTMLString(videoInformation.videoHTML, baseURL: nil)
        webView.scalesPageToFit = true
    }
    
    /**
     Called whenever the `BACK` button is pressed
     
     - parameters:
        - sender: the `UIButton` that was pressed
     */
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
