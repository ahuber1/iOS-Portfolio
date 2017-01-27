//
//  ViewController.swift
//  HelloWorld
//
//  Created by Andrew Huber on 12/25/16.
//  Copyright © 2016 Andrew Huber. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func welcomePressed(_ sender: UIButton) {
        background.isHidden = false
        titleImage.isHidden = false
        button.isHidden = true
    }

}

