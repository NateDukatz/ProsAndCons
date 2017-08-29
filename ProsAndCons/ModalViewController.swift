//
//  ModalViewController.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 8/22/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var weightPicker: UIPickerView!
    @IBOutlet weak var modalView: UIView!
    
    let weightPickerData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightPicker.layer.borderColor = UIColor.lightGray.cgColor
        weightPicker.layer.borderWidth = 1
        
        modalView.layer.cornerRadius = 10
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weightPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: weightPickerData[row])
    }
    
   

}
