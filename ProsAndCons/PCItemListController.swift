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
    
    init() {
        
        let fetchRequest: NSFetchRequest<PCItemList> = PCItemList.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("Error fetching PCItems")
        }
    }
    
    func create(PCItemListWithName name: String, weightPlusMinus: String = "-") {
        let _ = PCItemList(name: name, weightPlusMinus: weightPlusMinus)
        
        saveToPersistentStorage()
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
