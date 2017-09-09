//
//  AddNewTableViewCell.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 8/21/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit


protocol AddNewTableViewCellDelegate {
    func addProButtonTapped(_ sender: AddNewTableViewCell)
    func addConButtonTapped(_ sender: AddNewTableViewCell)
}

class AddNewTableViewCell: UITableViewCell {
    
    var delegate: AddNewTableViewCellDelegate?
    
    @IBOutlet weak var addConButton: UIButton!
    @IBOutlet weak var addProButton: UIButton!
    
    
    func setAddConButtonProperties () {
        
        addConButton.layer.borderColor = #colorLiteral(red: 0.7117882425, green: 0.8562296149, blue: 0.9285945596, alpha: 1).cgColor
    }
    
    func setAddProButtonProperties () {
       
        addProButton.layer.borderColor = #colorLiteral(red: 0.7117882425, green: 0.8562296149, blue: 0.9285945596, alpha: 1).cgColor
    }

    @IBAction func addProButtonTapped(_ sender: Any) {
        delegate?.addProButtonTapped(self)
    }
    
    @IBAction func addConButtonTapped(_ sender: Any) {
        delegate?.addConButtonTapped(self)
    }

}
