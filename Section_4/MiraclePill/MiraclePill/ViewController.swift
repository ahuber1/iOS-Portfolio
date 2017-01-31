//
//  ViewController.swift
//  MiraclePill
//
//  Created by Andrew Huber on 1/8/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var miraclePillEmoji: UIImageView!
    @IBOutlet weak var miraclePillsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var statePickerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var streetAddressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var successIndicator: UIImageView!
    @IBOutlet weak var divider: UIView!
    
    static let statesFileName = "states"
    
    var defaultButtonText: String? = nil
    let states = ViewController.constructStatesList()
    var editingStates = false
    var selectedRow: Int? = nil
    var offsetY: CGFloat? = nil
    var activeField: UITextField? = nil
    var originalContentInsets: UIEdgeInsets? = nil
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return UIInterfaceOrientationMask.portrait }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return UIInterfaceOrientation.portrait }
    override var shouldAutorotate: Bool { return UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.portrait }

    override func viewDidLoad() {
        super.viewDidLoad()
        statePicker.dataSource = self
        statePicker.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: .UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
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
    
    func keyboardWillBeHidden(_ notification: NSNotification) {
        if let contentInsets = originalContentInsets {
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
        
        originalContentInsets = nil
        activeField = nil
    }
    
    @IBAction func editingDidBegin(_ sender: UITextField) {
        activeField = sender
        activeField!.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func stateButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        editingStates = !editingStates // toggle between modes
        
        if defaultButtonText == nil {
            defaultButtonText = statePickerButton.titleLabel!.text!
        }
        
        if editingStates {
            statePicker.isHidden = false
            statePickerButton.setTitle("Tap here when you are done selecting the state", for: UIControlState.normal)
        }
        else {
            statePicker.isHidden = true
            
            if let row = selectedRow {
                statePickerButton.setTitle(ViewController.tupleToString(states[row]), for: UIControlState.normal)
            }
            else {
                statePickerButton.setTitle(defaultButtonText!, for: UIControlState.normal)
            }
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
    
    // Performs some action when someone selects a row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    @IBAction func buyNowButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        var results = [MiraclePillCheck]()
        
        results.append(checkEntry(entryDescription: "Full Name", entry: fullNameTextField.text, isButton: false, isNumeric: false))
        results.append(checkEntry(entryDescription: "Street Address", entry: streetAddressTextField.text, isButton: false, isNumeric: false))
        results.append(checkEntry(entryDescription: "City", entry: cityTextField.text, isButton: false, isNumeric: false))
        results.append(checkEntry(entryDescription: "State", entry: statePickerButton.titleLabel!.text, isButton: true, isNumeric: false))
        results.append(checkEntry(entryDescription: "Zip Code", entry: zipCodeTextField.text, isButton: false, isNumeric: true))
        results.append(checkEntry(entryDescription: "Quantity", entry: quantityTextField.text, isButton: false, isNumeric: true))
        
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
        
        miraclePillEmoji.isHidden = true
        miraclePillsLabel.isHidden = true
        priceLabel.isHidden = true
        scrollView.isHidden = true
        divider.isHidden = true
        successIndicator.isHidden = false
    }
    
    func checkEntry(entryDescription: String, entry: String?, isButton: Bool, isNumeric: Bool) -> MiraclePillCheck {
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
                return .emptyTextField(entryDescription: entryDescription)
            }
            else if isNumeric && containsLetters(entry!) {
                return .invalidEntry(entryDescription: entryDescription)
            }
            else {
                return .correct
            }
        }
    }
    
    func containsLetters(_ string: String) -> Bool {
        for character in string.characters {
            var thereIsADigit = false
            
            for digit in 0...9 {
                if String(character) == "\(digit)" {
                    thereIsADigit = true
                }
            }
            
            if thereIsADigit == false {
                return true
            }
        }
        
        return false
    }
    
    static func constructStatesList() -> [(abbreviation: String, fullName: String)] {
        var list = [(abbreviation: String, fullName: String)]()
        
        if let path = Bundle.main.path(forResource: statesFileName, ofType: "txt") {
            if let fileContents = try? String(contentsOfFile: path).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) {
                let lines = fileContents.components(separatedBy: "\n")
                
                for line in lines {
                    let trimmedLine = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    
                    if trimmedLine.characters.count > 0 && trimmedLine.contains(",") {
                        let components = trimmedLine.components(separatedBy: ",")
                        
                        if components.count == 2 {
                            list.append((abbreviation: components[0], fullName: components[1]))
                        }
                    }
                }
            }
            
        }
        
        return list
    }
    
    static func tupleToString(_ tuple: (abbreviation: String, fullName: String)) -> String {
        return "\(tuple.abbreviation) (\(tuple.fullName))"
    }
}

enum MiraclePillCheck {
    case correct
    case emptyTextField(entryDescription: String)
    case invalidEntry(entryDescription: String)
    case stateNotSelected
}
