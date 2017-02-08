//
//  ViewController.swift
//  DreamLister
//
//  Created by Andrew Huber on 1/24/17.
//  Copyright © 2017 Andrew Huber. All rights reserved.
//

import UIKit
import CoreData

/**
 This class contains the code for the main view controller in the DreamLister app, the one that displays all the items
 that the user would like to buy in a table view.
 */
class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    /** The table view */
    @IBOutlet weak var tableView: UITableView!
    
    /** The segmented control that the user can use to change the sorting order of the items in the table view */
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    /** Used to control fetches from Core Data, which is used to store the items that the user would like to buy */
    var fetchedResultsController: NSFetchedResultsController<Item>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the table view's delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set the font of the segmented control
        let attributes = [NSFontAttributeName : getAppFont(ofType: "Regular", withFontSize: 14)]
        segmentedControl.setTitleTextAttributes(attributes, for: .normal)
        
        // Fill in the table view
        attemptFetch()
    }

    // Dequeues a reusable cell from the table view, reconfigures it with data at an IndexPath, and returns
    // that cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    /**
        Fetches the Item from the NSFetchedResultsController at an IndexPath, and configures a table view cell
        with that Item that was fetches
     
        - parameters:
            - cell: the `ItemCell` to configure
            - indexPath: the `IndexPath` that was provided by `tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)`
     */
    private func configureCell(cell: ItemCell, indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        cell.configureCell(withItem: item)
    }
    
    // Returns the number of rows in a section of the table view according to Core Data (i.e., the number of Item objects
    // stored , or 0 if nothing is stored in Core Data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        else {
            return 0
        }
    }
    
    // Returns the number of sections in the table view according to Core Data, or 0 if nothing is stored in Core Data
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        else {
            return 0
        }
    }
    
    // Returns the height of the cells in the table view, which will always be 150
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    /**
        This function will fetch the data stored in Core Data, and will sort the data according to which 
        segment is selected in the segmented control.
     */
    private func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        // These sort descriptors map to the segments in the UISegmentedControl
        let sortDescriptors =
            [NSSortDescriptor(key: "created", ascending: false),
             NSSortDescriptor(key: "price", ascending: true),
             NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
        
        // Specify how the fetch request will sort the fetched items
        fetchRequest.sortDescriptors = [sortDescriptors[segmentedControl.selectedSegmentIndex]]
        
        // Create a new NSFetchedResultsController using the fetch request, and set its delegate to self
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        // Attempt to perform a fetch. If there is an error, show the user through a popup that an error occurred.
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            let popup = UIAlertController(title: "An error occurred while fetching the data. Nothing can be displayed.",
                                          message: error.description,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            popup.addAction(okAction)
            
            present(popup, animated: true, completion: nil)
        }
    }
    
    // Called whenever someone presses a new segment in the segmented control. This function performs a new
    // fetch, which sorts the data according to the segmented selected in the segmented control.
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        attemptFetch()
        tableView.reloadData()
    }
    
    // Called whenever the user inserts, deletes, updates, or moves an item in Core Data
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Called after controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchedRequestResult>)
    // is done.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // Called whenever the user selects a table view cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let objects = fetchedResultsController.fetchedObjects, objects.count > 0 {
            let item = objects[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        }
    }
    
    // Tells the ItemDetailsVC which Item was selected
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    // Called whenever the data in Core Data is deleted, inserted, updated, or moved.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
}

