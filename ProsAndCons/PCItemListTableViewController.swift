//
//  PCItemListTableViewController.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 8/24/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit
import CoreData

class PCItemListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

   
    override func viewDidLoad() {
        super.viewDidLoad()

        PCItemListController.shared.fetchedResultsController.delegate = self
        
    }

    @IBAction func addNewListButtonTapped(_ sender: Any) {
    
        let alertController = UIAlertController(title: "Add New List", message: "Type your list name here:", preferredStyle: .alert)
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.placeholder = "List Name"
        }
 
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_ : UIAlertAction) in
            
            if let nameTextField = alertController.textFields?.first {
                let name = nameTextField.text ?? ""
                
                
                PCItemListController.shared.create(PCItemListWithName: name)
                
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PCItemListController.shared.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PCItemListCell", for: indexPath) as? PCItemListTableViewCell else { return PCItemListTableViewCell() }
        
        let pcItemList = PCItemListController.shared.fetchedResultsController.object(at: indexPath)
        
        cell.update(withList: pcItemList)

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToPCItemList", let indexPath = tableView.indexPathForSelectedRow {
            guard let pcItemLists = PCItemListController.shared.fetchedResultsController.fetchedObjects else { return }
            let pcItemList = pcItemLists[indexPath.row]
            
            let pcItemVC = segue.destination as? PCItemViewController
            
            pcItemVC?.pcItemList = pcItemList
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

}
