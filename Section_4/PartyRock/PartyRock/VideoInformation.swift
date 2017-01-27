//
//  VideoInformation.swift
//  PartyRock
//
//  Created by Andrew Huber on 1/16/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

class VideoInformation {
    var imageURL: String { return _imageURL }
    var videoTitle: String { return _videoTitle }
    var videoURL: String? {
        //return
        
        let path = Bundle.main.path(forResource: "videoEmbed", ofType: "html")!
        
        if let embedHtml = try? String(contentsOfFile: path) {
            let html = embedHtml.replacingOccurrences(of: "IFRAME", with: "<iframe class=\"my_frame\" width=\"560\" height=\"313\" src=\"\(_videoSourceURL)\" frameborder=\"0\" allowfullscreen></iframe>")
            return html
        }
        else {
            return nil
        }
    }
    
    private let _imageURL: String
    private let _videoSourceURL: String
    private let _videoTitle: String
    
    init(imageURL: String, videoSourceURL: String, videoTitle: String) {
        _imageURL = imageURL
        _videoSourceURL = videoSourceURL
        _videoTitle = videoTitle
    }
}
