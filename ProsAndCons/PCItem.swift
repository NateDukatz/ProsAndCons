//
//  PCItem.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 8/10/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import Foundation
import CoreData

extension PCItem {
    
    convenience init(name: String, weight: Int16, proCon: Bool, pcItemList: PCItemList, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.name = name
        self.weight = weight
        self.proCon = proCon
        self.pcItemList = pcItemList
    }
}
