//
//  ViewController.swift
//  MiraclePill
//
//  Created by Andrew Huber on 1/8/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    /** The Miracle Pill icon in the top of the app. */
    @IBOutlet weak var miraclePillEmoji: UIImageView!
    
    /** The label that states "MIRACLE PILL" */
    @IBOutlet weak var miraclePillsLabel: UILabel!
    
    /** The label that displays the price of one Miracle Pill */
    @IBOutlet weak var priceLabel: UILabel!
    
    /** The `UIPickerView` that allows the user to select a state */
    @IBOutlet weak var statePicker: UIPickerView!
    
    /** The `UIButton` the user presses when he/she would like to display the `UIPickerView` */
    @IBOutlet weak var statePickerButton: UIButton!
    
    /** 
        The scroll view in which this entire _form_ (not the entire _view_) is embedded in 
        (i.e., all the content below `priceLabel` is inside this scroll view
     */
    @IBOutlet weak var scrollView: UIScrollView!
    
    /** The text field where the user enters his/her full name */
    @IBOutlet weak var fullNameTextField: UITextField!
    
    /** The text field where the user enters his/her street address */
    @IBOutlet weak var streetAddressTextField: UITextField!
    
    /** The text field where the user enters his/her city */
    @IBOutlet weak var cityTextField: UITextField!
    
    /** The text field where the user enters his/her zip code */
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    /** The text field where the user enters the number of Miracle Pills to buy */
    @IBOutlet weak var quantityTextField: UITextField!
    
    /** The success indicator that displays at the end */
    @IBOutlet weak var successIndicator: UIImageView!
    
    /** The grey divider between the top and bottom of the screen */
    @IBOutlet weak var divider: UIView!
    
    /** The name of the `.txt` file containing the states to display in `statePicker` */
    static let statesFileName = "states"
    
    /** An array containing the abbreviation of a state, followed by its full name (e.g., "MD (Maryland)")  */
    let states = ViewController.constructStatesList()
    
    /** `true` if the user is selecting a state in the `UIPickerView`, `false` if it is not. */
    var editingStates = false
    
    /** The row in the `UIPickerView` that was selected */
    var selectedRow: Int? = nil
    
    /** The `UITextField` that is currently active. */
    var activeField: UITextField? = nil
    
    /**
        In order to push the content in the scroll view up so the keyboard can appear and not cover up any text fields,
        the content insets of the `UIScrollView` are adjusted. However, the content insets before this adjustment are stored
        in this variable. 
     
        When the content insets need to be reverted, i.e., when the scroll view needs to be pushed back down, the application 
        needs to revert its content insets, and that is performed thanks to the fact that this variable stores the original
        content insets. After the original content insets are used in order to perform this reversal, this is set back to `nil`.
     */
    var originalContentInsets: UIEdgeInsets? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        statePicker.dataSource = self
        statePicker.delegate = self
        
        // Adds two observers that run when the keyboard will show and when the keyboard will be hidden.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
    }
    
    /**
        This function executes when the keyboard _will_ show.
     
        - parameters:
            - notification: The `NSNotification` that triggered this function's execution
     */
    @objc private func keyboardWillShow(_ notification: NSNotification) { // @objc allows this to work with selector b/c it's a private function
        let info = notification.userInfo!
        let kbSize = (info[UIKeyboardFrameBeginUserInfoKey]! as! CGRect).size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        if originalContentInsets == nil {
            originalContentInsets = scrollView.contentInset
        }
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var rect = self.view.frame
        rect.size.height -= kbSize.height
        
        if let activeField = activeField {
            if !rect.contains(activeField.frame.origin) {
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    /**
     This function executes when the keyboard _will_ show.
     
     - parameters:
     - notification: The `NSNotification` that triggered this function's execution
     */
    @objc private func keyboardWillBeHidden(_ notification: NSNotification) { // @objc allows this to work with selector b/c it's a private function
        if let contentInsets = originalContentInsets {
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
        
        originalContentInsets = nil
        activeField = nil
    }
    
    /**
     Called when editing begins in the text fields.
     
     - parameters:
        - sender: the `UITextField` that was selected
     */
    @IBAction func editingDidBegin(_ sender: UITextField) {
        activeField = sender
        activeField!.delegate = self
    }
    
    // Implementation for optional function in UIKit
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    /**
     Called when the user presees the button to select a state.
     
     - parameters:
        - sender: the `UITextField` that was selected.
     */
    @IBAction func stateButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        editingStates = !editingStates // toggle between modes
        
        if editingStates {
            statePicker.isHidden = false
            statePickerButton.setTitle("Tap here when you are done selecting the state", for: UIControlState.normal)
        }
        else {
            statePicker.isHidden = true
            
            // This happens when the user does not touch the UIPickerView. When this happens,
            // the app assumes that the user wants to pick the first state.
            if selectedRow == nil {
                selectedRow = 0
            }
            
            statePickerButton.setTitle(ViewController.tupleToString(states[selectedRow!]), for: UIControlState.normal)
        }
    }
    
    // Returns the number of columns in the UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns the number of rows that will appear in the UIPickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    // Returns what should be displayed at a given row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ViewController.tupleToString(states[row])
    }
    
    // Performs some action when someone selects a row in the UIPickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    /**
        Called whenever the user presses the "Buy Now" button
     
        - parameters:
            - sender: the `UIButton` that was pressed
     */
    @IBAction func buyNowButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        var results = [MiraclePillCheckResult]() // will contain the results of the error checks
        
        // Error check each of the fields
        results.append(checkEntry(fieldDescription: "Full Name",
                                  entry: fullNameTextField.text,
                                  isButton: false,
                                  isInteger: false))
        
        results.append(checkEntry(fieldDescription: "Street Address",
                                  entry: streetAddressTextField.text,
                                  isButton: false,
                                  isInteger: false))
        
        results.append(checkEntry(fieldDescription: "City",
                                  entry: cityTextField.text,
                                  isButton: false,
                                  isInteger: false))
        
        results.append(checkEntry(fieldDescription: "State",
                                  entry: statePickerButton.titleLabel!.text,
                                  isButton: true,
                                  isInteger: false))
        
        results.append(checkEntry(fieldDescription: "Zip Code",
                                  entry: zipCodeTextField.text,
                                  isButton: false,
                                  isInteger: true))
        
        results.append(checkEntry(fieldDescription: "Quantity",
                                  entry: quantityTextField.text,
                                  isButton: false,
                                  isInteger: true))
        
        // Checks each result in the error checking, and reports the first error discovered
        // to the user if there is an error in the form of a pop-up, and immediately returns 
        // from this function
        for result in results {
            let description: String?
            
            switch result {
            case .correct:
                description = nil
            case .emptyTextField(let entryDescription):
                description = "\(entryDescription) is empty."
            case .invalidEntry(let entryDescription):
                description = "\(entryDescription) can only contain digits from 0 to 9."
            default:
                description = "You must select a state"
            }
            
            if let errorMessage = description {
                let alert = UIAlertController(title: "Form is incomplete", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        
        // If control of the program got here, then all error checks passed. 
        // Hide all the views, and show the success indicator.
        miraclePillEmoji.isHidden = true
        miraclePillsLabel.isHidden = true
        priceLabel.isHidden = true
        scrollView.isHidden = true
        divider.isHidden = true
        successIndicator.isHidden = false
    }
    
    /**
        Performs error checking on one of the user's entries.
     
        - parameters:
            - fieldDescription: a human-readable description of the field currently being analyzed (e.g., "Street Address").
            - entry: the actual entry made by the user (i.e., what the user entered in this field).
            - isButton: `true` if this is a button, `false` if it is not.
            - isInteger: `true` if the entry should be an integer, `false` if should not.
     
        - returns: a `MiraclePillCheck` value containing the result of this check.
     */
    func checkEntry(fieldDescription: String, entry: String?, isButton: Bool, isInteger: Bool) -> MiraclePillCheckResult {
        if isButton {
            if entry == "Tap to select state" {
                return .stateNotSelected
            }
            else {
                return .correct
            }
        }
        else {
            if entry == nil || entry!.characters.count == 0 {
                return .emptyTextField(entryDescription: fieldDescription)
            }
            else if isInteger && !stringIsInteger(entry!) {
                return .invalidEntry(entryDescription: fieldDescription)
            }
            else {
                return .correct
            }
        }
    }
    
    /**
        Checks a string to see if it is an integer or not.
     
        - parameters:
            - string: the string to check
     
        - returns: `true` if the string contains an integer, `false` if it does not.
     */
    func stringIsInteger(_ string: String) -> Bool {
        for character in string.characters {
            var thereIsADigit = false
            
            for digit in 0...9 {
                if String(character) == "\(digit)" {
                    thereIsADigit = true
                }
            }
            
            if thereIsADigit == false {
                return false
            }
        }
        
        return true
    }
    
    /**
     Reads the text file containing abbreviations and full names of the states in the U.S., 
     and returns an array of tuples that contain two items: the states' abbreviation (e.g., "CA")
     and the states' full name (e.g., "California").
     
     - returns: an array of tuples that contain the states' abbreviation (e.g., "CA") and its full name
       (e.g., "California")
     */
    static func constructStatesList() -> [(abbreviation: String, fullName: String)] {
        if let path = Bundle.main.path(forResource: statesFileName, ofType: "txt") {
            if let fileContents = try? String(contentsOfFile: path).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) {
                let lines = fileContents.components(separatedBy: "\n") // each line of the text file
                var list = [(abbreviation: String, fullName: String)]()
                
                for line in lines {
                    let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    
                    if trimmedLine.characters.count > 0 && trimmedLine.contains(",") {
                        let components = trimmedLine.components(separatedBy: ",")
                        
                        if components.count == 2 {
                            list.append((abbreviation: components[0], fullName: components[1]))
                        }
                    }
                }
                
                return list
            }
        }
        
        fatalError("Unable to read \(statesFileName).txt")
    }
    
    /**
     Converts one of the tuples in the array that `constructStatesList()` created into
     a human-readable string in the format "<abbeviation> (<full name>)" 
     (e.g., "CA (California)"), and returns that string.
     
     - parameters:
     - tuple: the tuple to convert
     
     - returns: the human-readable string
     */
    static func tupleToString(_ tuple: (abbreviation: String, fullName: String)) -> String {
        return "\(tuple.abbreviation) (\(tuple.fullName))"
    }
}

/**
    An enum used by `checkEntry(fieldDescription: String, entry: String?, isButton: Bool, isInteger: Bool)`
    to check each field of the form that this app displays. This enum stores the result of the particular check.
 */
enum MiraclePillCheckResult {
    /** The check passed; the user's entry is correct */
    case correct
    
    /** 
        The text field is empty. `entryDescription` is a human-readable description of the field that was just 
        checked (e.g., "Street Address").
    */
    case emptyTextField(entryDescription: String)
    
    /**
     The text in the text field is invalid. `entryDescription` is a human-readable description of the field that 
     was just checked (e.g., "Street Address").
     */
    case invalidEntry(entryDescription: String)
    
    /** The user did not select a state in the `UIPickerView` */
    case stateNotSelected
}
