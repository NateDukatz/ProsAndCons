//
//  PCItemDetailTableViewController.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 10/12/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit

class PCItemDetailTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var weightPicker: UIPickerView!
    
    let weightPickerData = ["Low", "Medium", "High"]
    let altWeightPickerData = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
    
    var pcItem: PCItem? {
        didSet {
            if isViewLoaded {
                updateViews()
            }
        }
    }
    
    var pcItemList: PCItemList? {
        didSet {
            if isViewLoaded {
                updateViews()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateViews()
    }
    
    private func updateViews() {
        
        guard let pcItem = pcItem,
            let description = pcItem.name,
            isViewLoaded
            else { return }
        
        descriptionTextView.text = description
        
        if pcItemList?.altWeightOption == true {
            guard let pcItemWeight = pcItem.weight, let index = altWeightPickerData.index(of: pcItemWeight) else { return }
            weightPicker.selectRow(index, inComponent: 0, animated: true)
        } else {
            guard let pcItemWeight = pcItem.weight, let index = weightPickerData.index(of: pcItemWeight) else { return }
            weightPicker.selectRow(index, inComponent: 0, animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let pcItem = pcItem {
            pcItem.name = descriptionTextView.text
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pcItemList?.altWeightOption == true {
            return altWeightPickerData.count
        } else {
            return weightPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pcItemList?.altWeightOption == true {
            return altWeightPickerData[row]
        } else {
            return weightPickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if pcItemList?.altWeightOption == false {
            guard let pcItem = self.pcItem else { return }
            let weight = weightPickerData[row]
            
            switch (weight) {
            case "Low":
                pcItem.weight = "L"
            case "Medium":
                pcItem.weight = "M"
            case "High":
                pcItem.weight = "H"
            default:
                pcItem.weight = ""
            }
            
        } else {
            guard let pcItem = self.pcItem else { return }
            let weight = altWeightPickerData[row]
            pcItem.weight = weight
        }
    }
    
}
