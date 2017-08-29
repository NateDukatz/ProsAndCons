//
//  PCItemController.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 8/10/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import Foundation
import CoreData

class PCItemController {
    
    //static let shared = PCItemController()
    
//    var pcItems: [PCItem] {
//        
//        let fetchRequest: NSFetchRequest<PCItem> = PCItem.fetchRequest()
//        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        var results = [PCItem]()
//        
//        CoreDataStack.container.viewContext.performAndWait {
//            do {
//                results = try fetchRequest.execute()
//            } catch {
//                NSLog("Error fetching PCItems")
//            }
//        }
//        
//        return results
//    }
    
    
    func add(PCItemWithName name: String, weight: Int16, proCon: Bool, pcItemList: PCItemList) {
        
        let _ = PCItem(name: name, weight: weight, proCon: proCon, pcItemList: pcItemList)
        
        PCItemListController.shared.saveToPersistentStorage()
    }
    
    
    func delete(pcItem: PCItem) {
        
        if let moc = pcItem.managedObjectContext {
            moc.delete(pcItem)
        }
        PCItemListController.shared.saveToPersistentStorage()
    }
    
}
