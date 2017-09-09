//
//  PCItemListTableViewController.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 8/24/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit
import CoreData

class PCItemListTableViewController: UITableViewController {

//    var pcItemLists = [PCItemList]()
//    
//    func reloadArray() {
//        pcItemLists = PCItemListController.shared.pcItemLists
//        pcItemLists = PCItemListController.shared.pcItemLists.sorted(by: { $0.order < $1.order })
//    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.numberOfLines = 1
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.tableFooterView = UIView()

        //PCItemListController.shared.fetchedResultsController.delegate = self
        
//       reloadArray()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
                let order = Int16(PCItemListController.shared.pcItemLists.count)
                
                PCItemListController.shared.create(PCItemListWithName: name, order: order)
                
//                self.reloadArray()
                
                DispatchQueue.main.async(execute: {
                    self.tableView.insertRows(at: [IndexPath(row: Int(order), section: 0)], with: .automatic)
//                    self.tableView.reloadData()
                })
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PCItemListController.shared.pcItemLists.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PCItemListCell", for: indexPath) as? PCItemListTableViewCell else { return PCItemListTableViewCell() }
        
        let pcItemList = PCItemListController.shared.pcItemLists[indexPath.row]

        
        cell.update(withList: pcItemList)
        

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           // guard let pcItemLists = PCItemListController.shared.fetchedResultsController.fetchedObjects else { return }
            let pcItemList = PCItemListController.shared.pcItemLists[indexPath.row]
            PCItemListController.shared.delete(pcItemList: pcItemList)
//            reloadArray()
            tableView.deleteRows(at: [indexPath], with: .fade)
           
        }
    }
 

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
//        let pcItemList1 = PCItemListController.shared.fetchedResultsController.object(at: fromIndexPath)
//        let pcItemList2 = PCItemListController.shared.fetchedResultsController.object(at: to)
        
        let pcItemList1 = PCItemListController.shared.pcItemLists[fromIndexPath.row]
        let pcItemList2 = PCItemListController.shared.pcItemLists[to.row]
       
        let temp = pcItemList1.order
        pcItemList1.order = pcItemList2.order
        pcItemList2.order = temp
        
        PCItemListController.shared.saveToPersistentStorage()
        
//        let pcItemList = pcItemLists[fromIndexPath.row]
//        pcItemLists.remove(at: fromIndexPath.row)
//        PCItemListController.shared.delete(pcItemList: pcItemList)
//        pcItemLists.insert(pcItemList, at: to.row)
        
        //tableView.moveRow(at: fromIndexPath, to: to)
       
    }
 

    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToPCItemList", let indexPath = tableView.indexPathForSelectedRow {
            let pcItemLists = PCItemListController.shared.pcItemLists
            let pcItemList = pcItemLists[indexPath.row]
            
            let pcItemVC = segue.destination as? PCItemViewController
            
            pcItemVC?.pcItemList = pcItemList
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .delete:
//            guard let indexPath = indexPath else { return }
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        case .insert:
//            guard let newIndexPath = newIndexPath else { return }
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
//        case .move:
//            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
//            tableView.moveRow(at: indexPath, to: newIndexPath)
//            print("move")
//        case .update:
//            guard let indexPath = indexPath else { return }
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch type {
//        case .insert:
//            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
//        case .delete:
//            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
//        default:
//            break
//            
//        }
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }



}
