//
//  PCItemListController.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 8/24/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import Foundation
import CoreData

class PCItemListController {
    
    static let shared = PCItemListController()
    
    let fetchedResultsController: NSFetchedResultsController<PCItemList>
   
    //commented code is for putting fetched results into an array
    //var pcItemLists: [PCItemList] {
    init() {
        let fetchRequest: NSFetchRequest<PCItemList> = PCItemList.fetchRequest()

        //var results = [PCItemList]()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
       // CoreDataStack.container.viewContext.performAndWait {
            do {
                try fetchedResultsController.performFetch()
            } catch {
                NSLog("Error fetching PCItems")
            }
       // }
       // return results
    }
    
    @discardableResult func create(PCItemListWithName name: String, order: Int16, weightPlusMinus: String = "-") -> PCItemList {
        let pcItemList = PCItemList(name: name, weightPlusMinus: weightPlusMinus, order: order)
        
        saveToPersistentStorage()
        
        return pcItemList
    }
    
    func delete(pcItemList: PCItemList) {
        
        if let moc = pcItemList.managedObjectContext {
            moc.delete(pcItemList)
        }
        
        saveToPersistentStorage()
    }
    
    func saveToPersistentStorage() {
        let moc = CoreDataStack.context
        
        do {
            try moc.save()
        } catch let error {
            print("Couldn't save to persistent Store \(error)")
        }
    }
}
