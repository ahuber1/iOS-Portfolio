//
//  ViewController.swift
//  PartyRock
//
//  Created by Andrew Huber on 1/16/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

/**
    The view controller for the screen that lists all the music videos.
 
    - author: Andrew Huber
 */
class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /** The table view that displays all the music videos */
    @IBOutlet weak var tableView: UITableView!
    
    /** Makes the status bar (the topmost part of the screen displaying the time, battery status, etc.) use white text */
    override var preferredStatusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent }
    
    /** An array of `VideoInformation` objects the information that will be used in this app. */
    let information = MainVC.getInformation()

    // Assigns the table view's delegate and data source to self
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Sets a cell of the table view at a particular index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a cell that we can use again
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PartyCell", for: indexPath) as? PartyCell {
            cell.updateUI(withInfo: information[indexPath.row])
            return cell
        }
        else {
            return UITableViewCell() // should never happen!!!
        }
    }
    
    // Because there is only one section in the table view (i.e., 1 column), this funciton
    // returns the number of rows in this table view, which is information.count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return information.count
    }
    
    // Called after someone selects a row in the table view. All this funciton does is deslect
    // the cell and performs a seque to VideoVC to show the user the music video he/she selected.
    // The reason the cell is deselected is so the user does not see the same cell selected when
    // he/she returns to this screen.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let videoInformation = information[indexPath.row]
        performSegue(withIdentifier: "VideoVC", sender: videoInformation)
    }
    
    // Performs all the necessary preparation for the segue to take place. In this instance,
    // it sets VideoVC's videoInformation property so VideoVC knows which video to display.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VideoVC {
            if let videoInformation = sender as? VideoInformation {
                destination.videoInformation = videoInformation
            }
        }
    }
    
    /**
     Returns an array of `VideoInformation` objects that stores all the information for all the music
    videos that will be displayed in this app.
     
     - returns: an array of `VideoInformation` objects that stores all the information for all the music
       videos that will be displayed in this app.
     */
    private static func getInformation() -> [VideoInformation] {
        var information = [VideoInformation]()
        
        information.append(
            VideoInformation(imageURL: "https://i.ytimg.com/vi/q2dFMNPA9jQ/hqdefault.jpg?custom=true&w=336&h=188&stc=true&jpg444=true&jpgq=90&sp=68&sigh=uZ8koBCJsT-KdRSgIPvKwp5wzDI",
                             videoSourceURL: "https://www.youtube.com/embed/q2dFMNPA9jQ",
                             videoTitle: "The Way Back - Japanese Ver."))
        
        information.append(
            VideoInformation(imageURL: "https://i.ytimg.com/vi/CRLLWNIqb8w/hqdefault.jpg?custom=true&w=336&h=188&stc=true&jpg444=true&jpgq=90&sp=68&sigh=OeZAoK7lnBI2xyRNXTYACgg2WUs",
                             videoSourceURL: "https://www.youtube.com/embed/CRLLWNIqb8w",
                             videoTitle: "We are - Japanese Ver."))
        
        information.append(
            VideoInformation(imageURL: "https://i.ytimg.com/vi/_1NU-YkY3dk/hqdefault.jpg?custom=true&w=336&h=188&stc=true&jpg444=true&jpgq=90&sp=68&sigh=jEGakTQfN1hfrQ0mJP0L6g0lo5I",
                             videoSourceURL: "https://www.youtube.com/embed/_1NU-YkY3dk",
                             videoTitle: "Taking Off"))
        
        information.append(
            VideoInformation(imageURL: "https://i.ytimg.com/vi/UjZqcDYbvAE/hqdefault.jpg?custom=true&w=336&h=188&stc=true&jpg444=true&jpgq=90&sp=68&sigh=IptRcaXmqFWOAHm9ezukriTeOWg",
                             videoSourceURL: "https://www.youtube.com/embed/UjZqcDYbvAE",
                             videoTitle: "Mighty Long Fall"))
        
        information.append(
            VideoInformation(imageURL: "https://i.ytimg.com/vi/x9v8aNl6Aps/hqdefault.jpg?custom=true&w=336&h=188&stc=true&jpg444=true&jpgq=90&sp=68&sigh=D8zeuRfRZi5OMsLytPh5z4G2-fU",
                             videoSourceURL: "https://www.youtube.com/embed/x9v8aNl6Aps",
                             videoTitle: "Heartache"))
        
        information.append(
            VideoInformation(imageURL: "https://i.ytimg.com/vi/JWSRqWpWPzE/hqdefault.jpg?custom=true&w=336&h=188&stc=true&jpg444=true&jpgq=90&sp=68&sigh=459f3ve162UrXSH73C6KlKFROL0",
                             videoSourceURL: "https://www.youtube.com/embed/JWSRqWpWPzE",
                             videoTitle: "Cry Out"))
        
        // Sort the contents of the array alphabetically by video title
        information.sort(by: { $0.videoTitle < $1.videoTitle })
        
        return information
    }
}
