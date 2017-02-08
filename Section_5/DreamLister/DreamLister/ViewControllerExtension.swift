//
//  ViewControllerExtension.swift
//  DreamLister
//
//  Created by Andrew Huber on 2/8/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

// Adds the capability for searching for the first responder in a UIViewController
extension UIViewController {
    
    /** This `UIViewController`'s first responder, or `nil` if there is no first responder. */
    var firstResponder: UIView? { return findFirstResponder(self.view) }
    
    /**
        A recursive function that searches for the first responder
     
     - parameters:
     - currentView: the current `UIView` to look at to see if it is the first responder, 
     or if it has subviews that is the first responder.
     
     - returns: the first responder, or `nil` if there is no first responder.
     */
    private func findFirstResponder(_ currentView: UIView) -> UIView? {
        if currentView.isFirstResponder {
            return currentView
        }
        else {
            for subview in currentView.subviews {
                if let firstResponder = findFirstResponder(subview) {
                    return firstResponder
                }
            }
            
            return nil
        }
    }
}
