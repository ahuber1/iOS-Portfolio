//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Andrew Huber on 1/26/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    private let previousButton = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(previousButtonPressedOnKeyboardToolbar))
    private let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonPressedOnKeyboardToolbar))
    
    var activeTextField: CustomTextField? {
        if titleField.isFirstResponder {
            return titleField
        }
        else if priceField.isFirstResponder {
            return priceField
        }
        else if detailsField.isFirstResponder {
            return detailsField
        }
        else {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        titleField.delegate = self
        priceField.delegate = self
        detailsField.delegate = self
        
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
    
        getStores()
        
        if stores.count != 6 {
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
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
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
    
    func resignKeyboard() {
        if let activeTextField = activeTextField {
            activeTextField.resignFirstResponder()
        }
    }
    
    func previousButtonPressedOnKeyboardToolbar() {
        if let activeTextField = activeTextField {
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
    
    func nextButtonPressedOnKeyboardToolbar() {
        if let activeTextField = activeTextField {
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
    
    @IBAction func savePressed(_ sender: UIButton) {
        let item = itemToEdit == nil ? Item(context: context) : itemToEdit!
        
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
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
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
        else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbnailImage.image = image
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
     }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of columns
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update when selected
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        
        // If this fails, all we are doing is reusing a label, and changing the text
        if pickerLabel == nil {
            pickerLabel = UILabel()
            
            pickerLabel?.font = getAppFont(ofType: "Regular", withFontSize: 16)
            pickerLabel?.textAlignment = .center
        }
        
        pickerLabel?.text = stores[row].name
        return pickerLabel!
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle the error
        }
    }
    
    func loadItemData() {
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
