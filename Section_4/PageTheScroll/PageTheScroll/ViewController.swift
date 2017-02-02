//
//  ViewController.swift
//  PageTheScroll
//
//  Created by Andrew Huber on 1/10/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /** This app's scroll view */
    @IBOutlet weak var scrollView: UIScrollView!
    
    /** The image views that will be displayed in this app */
    var images = [UIImageView]()
    
    /** The lowest X value in the scroll view in this app using iOS's coordinate system */
    let minX: CGFloat = 0.0
    
    /** The highest X value in the scroll view in this app using iOS's coordinate system */
    var maxX: CGFloat { return scrollView.frame.size.width * CGFloat(images.count - 1) }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The scroll view does not extend all the way to the left and right side of the screen. 
        // Therefore, in order to make it possible for the user to scroll left and right from 
        // anywhere on the screen, these two swipe gesture recognizers are added.
        //
        // NOTE THAT THIS MUST BE ADDED HERE IN viewDidLoad()
        let leftSwipe  = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
        
        leftSwipe.direction  = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }

    // Loads the images into the scroll view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for x in 0...2 {
            let image = UIImage(named: "icon\(x).png")
            let imageView = UIImageView(image: image)
            images.append(imageView)
            
            let newX: CGFloat = (scrollView.frame.size.width / 2) + (scrollView.frame.size.width * CGFloat(x))
            
            imageView.frame = CGRect(x: newX - 75, y: (scrollView.frame.size.height / 2) - 75, width: 150.0, height: 150.0)
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count),
                                        height: scrollView.frame.size.height)
        scrollView.clipsToBounds = false // allows us to see the other icons on the left and right
    }
    
    /**
     Handles any swipes that were performed by the gesture recognizers. This moves the scroll view in the
     appropriate direction according to the direction.
     
     - parameters:
        - sender: the `UISwipeGestureRecognizer` that triggered this function call.
     */
    @objc private func handleSwipes(sender: UISwipeGestureRecognizer) {
        let currentX = scrollView.contentOffset.x
        let nextX: CGFloat
        
        if sender.direction == .right {
            nextX = currentX - scrollView.frame.size.width
        }
        else {
            nextX = currentX + scrollView.frame.size.width
        }
        
        // Only moves the scroll view only if there is something to scroll to
        if nextX >= minX && nextX <= maxX {
            scrollView.setContentOffset(CGPoint(x: nextX, y: scrollView.contentOffset.y), animated: true)
        }
    }
}
