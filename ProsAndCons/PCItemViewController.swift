//
//  ProsAndConsViewController.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 8/10/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit
import CoreData

class PCItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var weightPicker: UIPickerView!
    
    @IBOutlet weak var prosTableView: UITableView!
    @IBOutlet weak var consTableView: UITableView!
    
    @IBOutlet weak var prosWeightTotalLabel: UILabel!
    @IBOutlet weak var consWeightTotalLabel: UILabel!
    
    @IBOutlet weak var addProButton: UIButton!
    @IBOutlet weak var addConButton: UIButton!
    
    @IBOutlet weak var weightTotal: UILabel!
    
    
    var alertController = UIAlertController()
    let pcItemController = PCItemController()
    var pcItemList: PCItemList?
    
    var prosWeight = 0
    var consWeight = 0
    
    let altWeightPickerData = ["Select A Weight", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let weightPickerData = ["Select A Weight", "Low", "Medium", "High"]
    
    var pros = [PCItem]()
    var cons = [PCItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } 
        
        prosTableView.estimatedRowHeight = 50
        prosTableView.rowHeight = UITableViewAutomaticDimension
        
        consTableView.estimatedRowHeight = 50
        consTableView.rowHeight = UITableViewAutomaticDimension
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
        
        title = pcItemList?.name
        
        addProButton.layer.borderColor = UIColor.appYellow.cgColor
        addConButton.layer.borderColor = UIColor.appYellow.cgColor
        
        addProButton.setTitleColor(.appYellow, for: .normal)
        addConButton.setTitleColor(.appYellow, for: .normal)
        
        
        weightTotal.layer.cornerRadius = weightTotal.frame.width/2
        
        
        reloadTables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.navigationController?.isNavigationBarHidden = false
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.enableAllOrientation = true
        
        reloadTables()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.enableAllOrientation = true
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    func reloadTables() {
        
        guard let pcItems = pcItemList?.pcItems, let allItems = Array(pcItems) as? [PCItem] else { return }
        
        
        pros = allItems.filter { $0.proCon }
        cons = allItems.filter { !$0.proCon }
        
        prosTableView.reloadData()
        consTableView.reloadData()
        
        reloadWeights()
        
        weightPicker.selectRow(0, inComponent: 0, animated: true)
        
    }
    
    func reloadWeights() {
        var totalProWeight: Int = 0
        var nextProWeight: Int = 0
        for pro in pros {
            
            if pro.weight == "L" {
                nextProWeight = 1
            } else if pro.weight == "M" {
                nextProWeight = 2
            } else if pro.weight == "H" {
                nextProWeight = 3
            }
            
            totalProWeight = totalProWeight + nextProWeight

        }
        
        prosWeightTotalLabel.text = String(totalProWeight)
        
        var totalConWeight: Int = 0
        var nextConWeight: Int = 0
        for con in cons {
            
            if con.weight == "L" {
                nextConWeight = 1
            } else if con.weight == "M" {
                nextConWeight = 2
            } else if con.weight == "H" {
                nextConWeight = 3
            }
            
            totalConWeight = totalConWeight + nextConWeight
        }
        
        consWeightTotalLabel.text = String(totalConWeight)
        
        if pros.count == 0 && cons.count == 0 {
            pcItemList?.weightPlusMinus = "-"
            weightTotal.text = "-"
        } else {
            pcItemList?.weightPlusMinus = String(totalProWeight - totalConWeight)
            weightTotal.text = String(totalProWeight - totalConWeight)
        }
        
        PCItemListController.shared.saveToPersistentStorage()
        
        if totalProWeight - totalConWeight > 0 {
            weightTotal.textColor = #colorLiteral(red: 0, green: 0.5836070843, blue: 0.3329543817, alpha: 1)
            weightTotal.layer.borderColor = #colorLiteral(red: 0, green: 0.5836070843, blue: 0.3329543817, alpha: 1).cgColor
        } else if totalProWeight - totalConWeight < 0 {
            weightTotal.textColor = #colorLiteral(red: 0.8588235294, green: 0.1416355417, blue: 0.06344364766, alpha: 1)
            weightTotal.layer.borderColor = #colorLiteral(red: 0.8588235294, green: 0.1416355417, blue: 0.06344364766, alpha: 1).cgColor
        } else {
            weightTotal.textColor = #colorLiteral(red: 1, green: 0.5564047739, blue: 0.01442946099, alpha: 1)
            weightTotal.layer.borderColor = #colorLiteral(red: 1, green: 0.5564047739, blue: 0.01442946099, alpha: 1).cgColor
        }
        
    }
    
    @IBAction func addProButtonTap(_ sender: Any) {
        self.alertController = UIAlertController(title: "Add New Pro", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.placeholder = "Pro Name"
            
            newTextField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.placeholder = "Weight"
            newTextField.inputView = self.weightPicker
            
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_ : UIAlertAction) in
            self.weightPicker.selectRow(0, inComponent: 0, animated: true)
        }))
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (_ : UIAlertAction) in
            
            if let nameTextField = self.alertController.textFields?.first, let weightTextField = self.alertController.textFields?.last {
                let name = nameTextField.text ?? ""
                var weight = weightTextField.text ?? ""
               
                if self.pcItemList?.altWeightOption == false {
                    switch (weight) {
                    case "Low":
                        weight = "L"
                    case "Medium":
                        weight = "M"
                    case "High":
                        weight = "H"
                    default:
                        weight = ""
                    }
                }
                
                if let pcItemList = self.pcItemList {
                    
                    self.pcItemController.add(PCItemWithName: name, weight: weight, proCon: true, pcItemList: pcItemList)
                }
                
                DispatchQueue.main.async(execute: {
                    self.reloadTables()
                })
            }
        })
        
        alertController.addAction(saveAction)
        saveAction.isEnabled = false
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func addConButtonTap(_ sender: Any) {
        
        self.alertController = UIAlertController(title: "Add New Con", message: "Type your con here:", preferredStyle: .alert)
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.placeholder = "Con Name"
            
            newTextField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        }
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.inputView = self.weightPicker
            newTextField.placeholder = "Weight"
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_ : UIAlertAction) in
            self.weightPicker.selectRow(0, inComponent: 0, animated: true)
        }))
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (_ : UIAlertAction) in
            
            if let nameTextField = self.alertController.textFields?.first, let weightTextField = self.alertController.textFields?.last {
                
                let name = nameTextField.text ?? ""
                var weight = weightTextField.text ?? ""
                
                if self.pcItemList?.altWeightOption == false {
                    switch (weight) {
                    case "Low":
                        weight = "L"
                    case "Medium":
                        weight = "M"
                    case "High":
                        weight = "H"
                    default:
                        weight = ""
                    }
                }
                
                if !name.isEmpty || !weight.isEmpty {
                    
                    if let pcItemList = self.pcItemList {
                        self.pcItemController.add(PCItemWithName: name, weight: weight, proCon: false, pcItemList: pcItemList)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.reloadTables()
                    })
                }
            }
        })
        
        alertController.addAction(saveAction)
        saveAction.isEnabled = false
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func textChanged() {
        var enableSave = true
        alertController.textFields?.forEach { textField in
            if textField.text == nil || textField.text == "" {
                enableSave = false
            }
        }
        alertController.actions.last?.isEnabled = enableSave
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
        
        if let weightTextField = alertController.textFields?.last {
            if row != 0 {
                if pcItemList?.altWeightOption == true {
                    weightTextField.text = self.altWeightPickerData[row]
                } else {
                    weightTextField.text = self.weightPickerData[row]
                }
            } else {
                weightTextField.text = ""
            }
            textChanged()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == prosTableView {
            return self.pros.count // + 1
        } else {
            return cons.count //+ 1
        }
        
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableViewAutomaticDimension
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var pro: PCItem?
        var con: PCItem?
        
        if tableView == prosTableView {
            
            //For button in Cell
            //            if indexPath.row == (pros.count) {
            //
            //                guard let cell = tableView.dequeueReusableCell(withIdentifier: "addProCell", for: indexPath) as? AddNewTableViewCell else { return AddNewTableViewCell() }
            //
            //                cell.delegate = self
            //                cell.setAddProButtonProperties()
            //
            //                return cell
            //            }
            
            pro = pros[indexPath.row]
            
        } else {
            
            //For button in cell
            //            if indexPath.row == (cons.count) {
            //
            //                guard let cell = tableView.dequeueReusableCell(withIdentifier: "addConCell", for: indexPath) as? AddNewTableViewCell else { return AddNewTableViewCell() }
            //
            //                cell.delegate = self
            //                cell.setAddConButtonProperties()
            //
            //                return cell
            //            }
            
            con = cons[indexPath.row]
            
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PCItemTableViewCell else { return PCItemTableViewCell() }
        
        guard let pcItem = pro ?? con else { return PCItemTableViewCell() }
        
        cell.update(withItem: pcItem)
        
        return cell
    }
    
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            if tableView == prosTableView {
    //                let pcItem = pros[indexPath.row]
    //                pcItemController.delete(pcItem: pcItem)
    //                pros.remove(at: indexPath.row)
    //
    //                tableView.deleteRows(at: [indexPath], with: .fade)
    //
    //                reloadWeights()
    //
    //            } else {
    //                let pcItem = cons[indexPath.row]
    //                pcItemController.delete(pcItem: pcItem)
    //                cons.remove(at: indexPath.row)
    //
    //                tableView.deleteRows(at: [indexPath], with: .fade)
    //
    //                reloadWeights()
    //            }
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "🗑") { _, indexPath in
            if tableView == self.prosTableView {
                let pcItem = self.pros[indexPath.row]
                self.pcItemController.delete(pcItem: pcItem)
                self.pros.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                self.reloadWeights()
                
            } else {
                let pcItem = self.cons[indexPath.row]
                self.pcItemController.delete(pcItem: pcItem)
                self.cons.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                self.reloadWeights()
            }
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.9994946122, green: 0.3439007401, blue: 0.3113242984, alpha: 1)
        return [deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "prosCellSegue" {
            
            
            guard let indexPath = prosTableView.indexPathForSelectedRow else { return }
            let pcItem = pros[indexPath.row]
            let pcItemList = self.pcItemList
            
            let pcItemVC = segue.destination as? PCItemDetailTableViewController
            
            pcItemVC?.pcItem = pcItem
            pcItemVC?.pcItemList = pcItemList
        }
        
        if segue.identifier == "consCellSegue" {
            
            guard let indexPath = consTableView.indexPathForSelectedRow else { return }
            let pcItem = cons[indexPath.row]
            let pcItemList = self.pcItemList
            
            let pcItemVC = segue.destination as? PCItemDetailTableViewController
            
            pcItemVC?.pcItem = pcItem
            pcItemVC?.pcItemList = pcItemList
        }
        
        
    }
}





