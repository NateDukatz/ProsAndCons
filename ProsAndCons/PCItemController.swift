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
