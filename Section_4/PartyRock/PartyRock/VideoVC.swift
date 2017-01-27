//
//  VideoVC.swift
//  PartyRock
//
//  Created by Andrew Huber on 1/16/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

class VideoVC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var songTitleLabel: UILabel!
    
    var videoInformation: VideoInformation {
        get {
            return _videoInformation
        }
        set {
            _videoInformation = newValue
        }
    }
    
    private var _videoInformation: VideoInformation!

    override func viewDidLoad() {
        super.viewDidLoad()

        songTitleLabel.text = videoInformation.videoTitle
        
        webView.loadHTMLString(videoInformation.videoURL!, baseURL: nil)
        webView.scalesPageToFit = true
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
