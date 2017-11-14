//
//  EditingPCItemListTableViewCell.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 10/5/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit

protocol EditingPCItemListTableViewCellDelegate {
    func listTextChanged(_ sender: EditingPCItemListTableViewCell)
}

class EditingPCItemListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var weightPlusMinusLabel: UILabel!
    
    var delegate: EditingPCItemListTableViewCellDelegate?
    
    @IBAction func textFieldEdited(_ sender: Any) {
        delegate?.listTextChanged(self)
    }
    
    
    func update(withList pcItemList: PCItemList) {
        nameTextfield.text = pcItemList.name
        weightPlusMinusLabel.text = pcItemList.weightPlusMinus
        
        guard let plusMinus = pcItemList.weightPlusMinus else { return }
        
        if let plusMinus = Int(plusMinus) {
            
            if plusMinus > 0 {
                weightPlusMinusLabel.textColor = #colorLiteral(red: 0, green: 0.5836070843, blue: 0.3329543817, alpha: 1)
            } else if plusMinus < 0 {
                weightPlusMinusLabel.textColor = #colorLiteral(red: 0.8588235294, green: 0.1416355417, blue: 0.06344364766, alpha: 1)
            } else if plusMinus == 0 {
                weightPlusMinusLabel.textColor = #colorLiteral(red: 1, green: 0.5564047739, blue: 0.01442946099, alpha: 1)
            }
        }
    }

}
