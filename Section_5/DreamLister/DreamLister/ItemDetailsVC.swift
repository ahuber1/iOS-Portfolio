//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Andrew Huber on 1/26/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit
import CoreData

/**
    This class contains the code for the view controller in the DreamLister app that displays an item
    that the user would like to buy in a table view so that the user can edit it. This is also the the view
    controller that allows the user to edit and delete an item.
 */
class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    /** The picker view that is used to select a store */
    @IBOutlet weak var storePicker: UIPickerView!
    
    /** Shows the name of the item */
    @IBOutlet weak var titleField: CustomTextField!
    
    /** Shows the price of the item */
    @IBOutlet weak var priceField: CustomTextField!
    
    /** Shows the description of the tiem */
    @IBOutlet weak var detailsField: CustomTextField!
    
    /** Shows the thumbnail of the item */
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    /** A list of all the stores */
    var stores = [Store]()
    
    /** The `Item` object that will be edited, or `nil` when a new `Item` object is being created in this VC */
    var itemToEdit: Item?
    
    /** Allows the user to pick an image for this item */
    var imagePicker: UIImagePickerController!
    
    /** 
        The `"Previous"` button used in the toolbar that shows above the keyboard. With this button, the user can
        easily go to the previous text field. 
     */
    private let previousButton = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(previousButtonPressedOnKeyboardToolbar))
    
    /**
     The `"Next"` button used in the toolbar that shows above the keyboard. With this button, the user can
     easily go to the next text field.
     */
    private let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonPressedOnKeyboardToolbar))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Sets the text for the back button on the navigation controller
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        // Sets the store picker's delegate and data source
        storePicker.delegate = self
        storePicker.dataSource = self
        
        // Creates the image picker, and sets its delegate
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Sets the text field's delegates
        titleField.delegate = self
        priceField.delegate = self
        detailsField.delegate = self
        
        // Creates the toolbar that appears on top of the keyboard
        let kbToolbar = UIToolbar()
        kbToolbar.barStyle = .default
        kbToolbar.sizeToFit()
        
        let emptySpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignKeyboard))
        let itemsArray = [previousButton, emptySpace, nextButton, flexButton, doneButton]
        
        emptySpace.width = 10.0
        kbToolbar.setItems(itemsArray, animated: true)
        
        titleField.inputAccessoryView = kbToolbar
        priceField.inputAccessoryView = kbToolbar
        detailsField.inputAccessoryView = kbToolbar
    
        // Get the stores from Core Data, and store them in the stores array
        getStores()
        
        // If the stores have yet to be added, add them to Core Data, and call getStores() again
        if stores.count == 0 {
            let store1 = Store(context: context)
            let store2 = Store(context: context)
            let store3 = Store(context: context)
            let store4 = Store(context: context)
            let store5 = Store(context: context)
            let store6 = Store(context: context)
    
            store1.name = "Best Buy"
            store2.name = "Tesla Dealership"
            store3.name = "Frys Electronics"
            store4.name = "Target"
            store5.name = "Amazon"
            store6.name = "K Mart"
            
            ad.saveContext()
            getStores()
        }
        
        // If there is an item to edit, load it into this VC
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    // Enables and disables previousButton and nextButton depending on the text field that was selected so that one
    // can hit the previous button when the user can go to a previous text field, and one can hit the next button 
    // when the user can go to the next text field.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case titleField:
            previousButton.isEnabled = false
            nextButton.isEnabled = true
        case priceField:
            previousButton.isEnabled = true
            nextButton.isEnabled = true
        case detailsField:
            previousButton.isEnabled = true
            nextButton.isEnabled = false
        default:
            fatalError("An unknown text field began editing")
        }
        
        if textField.text != nil {
            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        }
    }

    // Called when the 'return' key is pressed on the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField {
        case titleField:
            priceField.becomeFirstResponder()
        case priceField:
            detailsField.becomeFirstResponder()
        case detailsField:
            detailsField.resignFirstResponder()
        default:
            fatalError("An invalid UITextField was passed in.")
        }
        
        return true;
    }
    
    /** Call this to dismiss the keyboard. */
    @objc private func resignKeyboard() {
        if let activeTextField = firstResponder {
            activeTextField.resignFirstResponder()
        }
    }
    
    /** 
        Called whenever the `"Previous"` button is pressed on the keyboard toolbar.
        A fatal error will occur when it is not possible to select the "previous" text field. 
     */
    @objc private func previousButtonPressedOnKeyboardToolbar() {
        if let activeTextField = firstResponder {
            switch activeTextField {
            case titleField:
                fatalError("Cannot go to previous text field")
            case priceField:
                titleField.becomeFirstResponder()
            case detailsField:
                priceField.becomeFirstResponder()
            default:
                fatalError("The active text field is unknown")
            }
        }
    }
    
    /**
        Called whenever the `"Next"` button is pressed on the keyboard toolbar.
        A fatal error will occur when it is not possible to select the "next" text field.
     */
    func nextButtonPressedOnKeyboardToolbar() {
        if let activeTextField = firstResponder {
            switch activeTextField {
            case titleField:
                priceField.becomeFirstResponder()
            case priceField:
                detailsField.becomeFirstResponder()
            case detailsField:
                fatalError("Cannot go the next text field")
            default:
                fatalError("The active text field is unknown")
            }
        }
    }
    
    // Called whenever the user presses the "Save Item" button.
    @IBAction func savePressed(_ sender: UIButton) {
        // Create a new Item object if one does not exist. Otherwise, use itemToEdit
        let item = itemToEdit == nil ? Item(context: context) : itemToEdit!
        
        // Set the Item object's properties
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = Double(price)!
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        let picture = Image(context: context)
        picture.image = thumbnailImage.image
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)] // column 0
        item.toImage = picture
        
        // Save Item object to Core Data
        ad.saveContext()
        
        // Go back one screen
        _ = navigationController?.popViewController(animated: true)
    }

    // Called whenever the red trash can is pressed
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        // If there is an Item to delete in Core Data, display an Action Sheet asking for confirmation, and delete ONLY
        // when the user confirms the deletion. Otherwise, do nothing.
        if itemToEdit != nil {
            
            let actionSheet = UIAlertController(title: nil, message: "Are you sure you would like to delete this item?", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                context.delete(self.itemToEdit!)
                ad.saveContext()
                _ = self.navigationController?.popViewController(animated: true)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            actionSheet.addAction(deleteAction)
            actionSheet.addAction(cancelAction)
            
            present(actionSheet, animated: true, completion: nil)
        }
        // If there is no Item to delete in Core Data, just go back to the previous screen.
        else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    // Called whenever the user presses the thumbnail image
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Called when the user has finished selecting an image from his/her Camera Roll
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbnailImage.image = image
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
     }
    
    // Returns the number of rows in the one and only component of the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    // There will only be one column in the picker view, so return 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        
        // If this test fails, reuse the label. If this test succeeds, create a new UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            
            pickerLabel?.font = getAppFont(ofType: "Regular", withFontSize: 16)
            pickerLabel?.textAlignment = .center
        }
        
        pickerLabel?.text = stores[row].name
        return pickerLabel!
    }
    
    /**
        Fetches the stores from Core Data, and stores them in the `stores` array.
     */
    private func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle the error
        }
    }
    
    /**
        With `itemToEdit` set, call this function in order to set the text fields, the image views, and all
        the other views in this VC with the information stored in `itemToEdit`
     
        - precondition: `itemToEdit` is set.
     */
    private func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = item.priceString
            detailsField.text = item.details
            thumbnailImage.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                var index = 0
                
                while index < stores.count {
                    if stores[index].name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        index = stores.count
                    }
                    
                    index += 1
                }
            }
        }
    }
}
