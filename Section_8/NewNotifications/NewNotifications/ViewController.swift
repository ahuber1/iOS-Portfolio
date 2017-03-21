//
//  ViewController.swift
//  NewNotifications
//
//  Created by Andrew Huber on 3/21/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. REQUEST PERMISSION
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
            
            if granted {
                print("Notification access granted")
            }
            else {
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    print("Permission was NOT granted, but no error was given.")
                }
            }
        })
        
    }
    
    @IBAction func notifyButtonTapped(_ sender: UIButton) {
        scheduleNotification(inSeconds: 5, { success in
            if success {
                print("Successfully scheduled notification!")
            }
            else {
                print("Error scheduling notification")
            }
        } )
    }
    
    func scheduleNotification(inSeconds seconds: TimeInterval, _ completion: @escaping (_ success: Bool) -> ()) {
        // Add an attachment
        let myImage = "rick_grimes"
        guard let imageURL = Bundle.main.url(forResource: myImage, withExtension: "gif") else {
            completion(false)
            return
        }
        
        let attachment = try! UNNotificationAttachment(identifier: "MyNoficiation", url: imageURL, options: nil)
        
        let notif = UNMutableNotificationContent()
        notif.title = "New Notification"
        notif.subtitle = "These are great!"
        notif.body = "The new notification options in iOS 10 are what I've always dreamed of ;-)"
        
        notif.attachments = [attachment]
        
        // ONLY FOR EXTENSION
        notif.categoryIdentifier = "myNotificationCategory"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "MyNotification", content: notif, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print(error!)
                completion(false)
            }
            else {
                completion(true)
            }
        })
    }
}

