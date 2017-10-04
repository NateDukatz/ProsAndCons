//
//  PCItemListViewController.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 8/24/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices

class PCItemListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var ItemListTableView: UITableView!
    
    var searchController = UISearchController()
    var filteredArray = [PCItemList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetArray()
        
        if #available(iOS 11.0, *) {
            ItemListTableView.dragDelegate = self
            ItemListTableView.dropDelegate = self
            ItemListTableView.dragInteractionEnabled = true
        }
        
        // MARK: - Search Bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.barTintColor = .appBlue
        searchController.searchBar.barStyle = .black
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .appYellow
        // searchController.searchBar.searchBarStyle = .prominent
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
//            navigationController?.navigationBar.prefersLargeTitles = true
//            navigationItem.largeTitleDisplayMode = .automatic
            
            
        } else {
            ItemListTableView.tableHeaderView = searchController.searchBar
            ItemListTableView.contentOffset.y = searchController.searchBar.frame.size.height
        }
        
        
        
        
        
        
        
        let label = UILabel()
        label.numberOfLines = 1
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        ItemListTableView.tableFooterView = UIView()
        
        //        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "stars"), for: .default)
        
        PCItemListController.shared.fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.enableAllOrientation = false
        //self.navigationController?.isNavigationBarHidden = false
        
        if let row = ItemListTableView.indexPathForSelectedRow {
            ItemListTableView.deselectRow(at: row, animated: false)
        }
        
        ItemListTableView.flashScrollIndicators()
        
        ItemListTableView.reloadData()
        reloadTableView()
        //        if searchController.isActive == true {
        //            self.navigationController?.isNavigationBarHidden = false
        //        }
    }
    
    func reloadTableView() {
        if filteredArray.count == 0 {
            ItemListTableView.isHidden = true
            searchController.searchBar.isHidden = true
        } else {
            ItemListTableView.isHidden = false
            searchController.searchBar.isHidden = false
        }
    }
    
    func resetArray() {
        do {
            try PCItemListController.shared.fetchedResultsController.performFetch()
        } catch {
            NSLog("Error fetching PCItems")
        }
        
        guard let objectArray = PCItemListController.shared.fetchedResultsController.fetchedObjects else { return }
        filteredArray = objectArray.sorted(by: { $0.order < $1.order })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        defer {
            ItemListTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        guard let text = searchController.searchBar.text, let objectArray = PCItemListController.shared.fetchedResultsController.fetchedObjects,!text.characters.isEmpty else { resetArray(); return }
        filteredArray = objectArray.filter({ (pcItemList: PCItemList) -> Bool in
            guard let name = pcItemList.name else { return false }
            if (name.lowercased().contains(text.lowercased())) {
                return true
            } else {
                return false
            }
        })
    }
    
   
    
    
    @IBAction func addNewListButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add New List", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.placeholder = "List Name"
            newTextField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_ : UIAlertAction) in
            
            if let nameTextField = alertController.textFields?.first {
                let name = nameTextField.text ?? ""
                let order = Int16(self.filteredArray.count)
                
                let pcItemList = PCItemListController.shared.create(PCItemListWithName: name, order: order)
                self.resetArray()
                
                DispatchQueue.main.async(execute: {
                    self.ItemListTableView.insertRows(at: [IndexPath(row: Int(order), section: 0)], with: .automatic)
                    self.ItemListTableView.reloadData()
                    self.reloadTableView()
                })
                guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PCItemViewController") as? PCItemViewController else { return }
                viewController.pcItemList = pcItemList
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }))
        alertController.actions[1].isEnabled = false
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func textChanged(_ sender: Any) {
        let tf = sender as? UITextField
        var resp: UIResponder! = tf
        
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        
        alert.actions[1].isEnabled = (tf?.text != "" && tf?.text != nil)
        
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PCItemListCell", for: indexPath) as? PCItemListTableViewCell else { return PCItemListTableViewCell() }
        
        let pcItemList = filteredArray[indexPath.row]
        
        cell.update(withList: pcItemList)
        
        
        return cell
        
    }
    
    
    // MARK: - Editing functions
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//
//        return true
//    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        ItemListTableView.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let pcItemList = filteredArray[fromIndexPath.row]
        
        filteredArray.remove(at: fromIndexPath.row)
        filteredArray.insert(pcItemList, at: to.row)
        
        
        
        for (index, pcItemList) in filteredArray.enumerated() {
            pcItemList.order = Int16(index)
            guard let objectIndexPath = PCItemListController.shared.fetchedResultsController.indexPath(forObject: pcItemList) else { return }
            PCItemListController.shared.fetchedResultsController.object(at: objectIndexPath).name = pcItemList.name
            PCItemListController.shared.fetchedResultsController.object(at: objectIndexPath).order = pcItemList.order
        }
        
        PCItemListController.shared.saveToPersistentStorage()
        self.resetArray()
        
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // PRE iOS 11 Delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "🗑") { _, indexPath in
            let pcItemList = self.filteredArray[indexPath.row]
            self.filteredArray.remove(at: indexPath.row)
            PCItemListController.shared.delete(pcItemList: pcItemList)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.resetArray()
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.9994946122, green: 0.3439007401, blue: 0.3113242984, alpha: 1)
        reloadTableView()
        return [deleteAction]
    }
    
//     Old Delete
//     Override to support editing the table view.
//        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//            if editingStyle == .delete {
//               // guard let pcItemLists = PCItemListController.shared.fetchedResultsController.fetchedObjects else { return }
//                let pcItemList = filteredArray[indexPath.row]
//
//                PCItemListController.shared.delete(pcItemList: pcItemList)
//                filteredArray.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                reloadArray()
//
//
//            }
//        }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ToPCItemList", let indexPath = ItemListTableView.indexPathForSelectedRow {
            let pcItemLists = filteredArray
            let pcItemList = pcItemLists[indexPath.row]
            
            let pcItemVC = segue.destination as? PCItemViewController
            
            pcItemVC?.pcItemList = pcItemList
        }
        
        searchController.searchBar.isHidden = true
        searchController.searchBar.resignFirstResponder()
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

//MARK: - iOS 11 swipe and drag
@available(iOS 11.0, *)
extension PCItemListViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
    //ios 11 delete, not currently working correctly
    //    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        let delete = UIContextualAction(style: .destructive, title: "🗑") { (_, _, _) in
    //            let pcItemList = self.filteredArray[indexPath.row]
    //            self.filteredArray.remove(at: indexPath.row)
    //            PCItemListController.shared.delete(pcItemList: pcItemList)
    //            self.tableView.deleteRows(at: [indexPath], with: .fade)
    //
    //        }
    //       delete.backgroundColor = #colorLiteral(red: 1, green: 0.3442174489, blue: 0.3098530093, alpha: 1)
    //
    //        return UISwipeActionsConfiguration(actions: [delete])
    //    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let pcItemList = filteredArray[indexPath.row]
        let data = pcItemList.description.data(using: .utf8)
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    func tableView(_ tableView: UITableView, dragSessionIsRestrictedToDraggingApplication session: UIDragSession) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        // Do nothing for now and take advantage of tableView(moveAt:to:)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}

