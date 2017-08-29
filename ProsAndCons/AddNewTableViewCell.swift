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

    @IBAction func addProButtonTapped(_ sender: Any) {
        delegate?.addProButtonTapped(self)
    }
    
    @IBAction func addConButtonTapped(_ sender: Any) {
        delegate?.addConButtonTapped(self)
    }

}
