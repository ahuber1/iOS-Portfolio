//
//  AppDelegate.swift
//  PushMyNotifs
//
//  Created by Andrew Huber on 3/21/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 8.0, *) {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types: UIRemoteNotificationType = [.alert, .badge, .sound]
            application.registerForRemoteNotifications(matching: types)
        }
        
        FIRApp.configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification(notification:)), name: NSNotification.Name.firInstanceIDTokenRefresh, object: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        FIRMessaging.messaging().disconnect() // close active connection to server
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFirebaseConnectionManager()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("Instance ID token: \(refreshedToken)")
        
        connectToFirebaseConnectionManager()
    }

    func connectToFirebaseConnectionManager() {
        FIRMessaging.messaging().connect(completion: { (error) in
            if error != nil {
                print("Unable to connect \(error)")
            } else {
                print("Connected to Firebase Connection Manager")
            }
        } )
    }
}
