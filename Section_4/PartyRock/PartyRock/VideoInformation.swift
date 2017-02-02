//
//  VideoInformation.swift
//  PartyRock
//
//  Created by Andrew Huber on 1/16/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

/**
    A class containing all the information for a music video
 
    - author: Andrew Huber
 */
class VideoInformation {
    /** The getter for the URL for the thumbnail for the music video */
    var imageURL: String { return _imageURL }
    
    /** The getter for the title of the video */
    var videoTitle: String { return _videoTitle }
    
    /** The HTML code that should be displayed in the web view for the video. */
    var videoHTML: String {
        
        // Get the file path of videoEmbed.html
        let path = Bundle.main.path(forResource: "videoEmbed", ofType: "html")
        
        if let path = path {
            if let embedHtml = try? String(contentsOfFile: path) {
                let html = embedHtml.replacingOccurrences(of: "IFRAME",
                                                          with: "<iframe class=\"my_frame\" width=\"560\" height=\"313\" src=\"\(_videoSourceURL)\" frameborder=\"0\" allowfullscreen></iframe>")
                return html
            }
            else {
                fatalError("Unable to read videoEmbed.html")
            }
        }
        else {
            fatalError("videoEmbed.html was not found")
        }
    }
    
    /** The URL for the thumbnail for the music video */
    private let _imageURL: String
    
    /** The URL for the video. **This must be the embed URL!** */
    private let _videoSourceURL: String
    
    /** The title of the music video. */
    private let _videoTitle: String
    
    /**
     Creates a new `VideoInformation` object
     
     - parameters:
        - imageURL: the URL for the thumbnail for the music video.
        - videoSourceURL: the URL for the music video. **This must be the embed URL!**
        - videoTitle: the title of the music video
     */
    init(imageURL: String, videoSourceURL: String, videoTitle: String) {
        _imageURL = imageURL
        _videoSourceURL = videoSourceURL
        _videoTitle = videoTitle
    }
}
