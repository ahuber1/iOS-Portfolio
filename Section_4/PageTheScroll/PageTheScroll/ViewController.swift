//
//  ViewController.swift
//  PageTheScroll
//
//  Created by Andrew Huber on 1/10/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var images = [UIImageView]() // in this app, we will not use this array, but it is good to keep a reference to the UIImageViews in most cases
    
    let minX: CGFloat = 0.0
    var maxX: CGFloat { return scrollView.frame.size.width * CGFloat(images.count - 1) }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipe  = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
        
        leftSwipe.direction  = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }

    override func viewDidAppear(_ animated: Bool) {
        for x in 0...2 {
            let image = UIImage(named: "icon\(x).png")
            let imageView = UIImageView(image: image)
            images.append(imageView)
            
            let newX: CGFloat = (scrollView.frame.size.width / 2) + (scrollView.frame.size.width * CGFloat(x))
            
            imageView.frame = CGRect(x: newX - 75, y: (scrollView.frame.size.height / 2) - 75, width: 150.0, height: 150.0)
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
        scrollView.clipsToBounds = false // allows us to see the other icons on the left and right
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        let currentX = scrollView.contentOffset.x
        let nextX: CGFloat
        
        if sender.direction == .right {
            nextX = currentX - scrollView.frame.size.width
        }
        else {
            nextX = currentX + scrollView.frame.size.width
        }
        
        if nextX >= minX && nextX <= maxX {
            scrollView.setContentOffset(CGPoint(x: nextX, y: scrollView.contentOffset.y), animated: true)
        }
    }
}
