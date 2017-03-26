//
//  ViewController.swift
//  PushMyNotifs
//
//  Created by Andrew Huber on 3/21/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRMessaging.messaging().subscribe(toTopic: "/topics/news")
    }
}

