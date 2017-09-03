//
//  PCItemList.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 8/24/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import Foundation
import CoreData

extension PCItemList {
    
    convenience init(name: String, weightPlusMinus: String, order: Int16, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.name = name
        self.weightPlusMinus = weightPlusMinus
        self.order = order
    }
}
