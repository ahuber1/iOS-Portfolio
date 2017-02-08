//
//  MaterialView.swift
//  DreamLister
//
//  Created by Andrew Huber on 1/24/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//
//  Description: This file contains code for an extension of UIView object.
//               This extension allows one to make UIViews appear like Google's
//               apps that use material design, i.e., it adds shadows to UIView
//               objects such that they appear to be sheets of paper ("material").

import UIKit

/** The variable that `materialDesign` accesses and sets. */
private var _materialDesign = false

extension UIView {

    /**
     A property of `UIView` that allows `UIView`s to appear like Google's apps that
     use material design, i.e., it adds shadows to this `UIView` so that they appear
     to be sheets of paper ("material"). 
     
     This property is `IBInspectable`, so one can alter this in Interface Builder. Set
     this to `true` in order to make this UIView appear as "material", `false` if you 
     do not.
     */
    @IBInspectable var materialDesign: Bool {
        get {
            return _materialDesign
        }
        set {
            _materialDesign = newValue
            
            if _materialDesign {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
            } else {
                self.layer.masksToBounds = true // APH added this
                self.layer.cornerRadius = 0.0
                self.layer.shadowOpacity = 0.0
                self.layer.shadowRadius = 0.0
                self.layer.shadowColor = nil
            }
        }
    }
}
