//
//  PCItemTableViewCell.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 8/16/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit

class PCItemTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    func update(withItem pcItem: PCItem) {
        nameLabel.text = pcItem.name
        weightLabel.text = String(pcItem.weight)
//        if pcItem.weight <= 3 {
//            weightLabel.textColor = #colorLiteral(red: 0.8588235294, green: 0.1416355417, blue: 0.06344364766, alpha: 1)
//        } else if pcItem.weight <= 7 {
//            weightLabel.textColor = #colorLiteral(red: 1, green: 0.5564047739, blue: 0.01442946099, alpha: 1)
//        } else {
//            weightLabel.textColor = #colorLiteral(red: 0, green: 0.5836070843, blue: 0.3329543817, alpha: 1)
//        }

    }
}
