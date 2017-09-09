//
//  ProsAndConsViewController.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 8/10/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit
import CoreData

class PCItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddNewTableViewCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var weightPicker: UIPickerView!
    
    @IBOutlet weak var prosTableView: UITableView!
    @IBOutlet weak var consTableView: UITableView!
    
    @IBOutlet weak var prosWeightTotalLabel: UILabel!
    @IBOutlet weak var consWeightTotalLabel: UILabel!
    
    var alertController = UIAlertController()
    
    let pcItemController = PCItemController()
    
    var pcItemList: PCItemList?
    
    var prosWeight = 0
    var consWeight = 0
    
    let weightPickerData = ["Select A Weight", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    
   
    func addProButtonTapped(_ sender: AddNewTableViewCell) {
        self.alertController = UIAlertController(title: "Add New Pro", message: "Type your pro here:", preferredStyle: .alert)
       
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.placeholder = "Pro Name"
        }
        
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.placeholder = "Weight"
            newTextField.inputView = self.weightPicker
        }
       
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_ : UIAlertAction) in
            self.weightPicker.selectRow(0, inComponent: 0, animated: true)
        }))

        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_ : UIAlertAction) in
            
            if let nameTextField = self.alertController.textFields?.first, let weightTextField = self.alertController.textFields?.last {
                let name = nameTextField.text ?? ""
                let weight = weightTextField.text ?? ""
                
                if let weight = Int16(weight), let pcItemList = self.pcItemList {
                    self.pcItemController.add(PCItemWithName: name, weight: weight, proCon: true, pcItemList: pcItemList)
                }
                
                DispatchQueue.main.async(execute: {
                    self.reloadTables()
                })
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func addConButtonTapped(_ sender: AddNewTableViewCell) {
        self.alertController = UIAlertController(title: "Add New Con", message: "Type your con here:", preferredStyle: .alert)
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.placeholder = "Con Name"
        }
        
        alertController.addTextField { (newTextField: UITextField) in
            newTextField.inputView = self.weightPicker
            newTextField.placeholder = "Weight"
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_ : UIAlertAction) in
            self.weightPicker.selectRow(0, inComponent: 0, animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_ : UIAlertAction) in
            
            if let nameTextField = self.alertController.textFields?.first, let weightTextField = self.alertController.textFields?.last {
                let name = nameTextField.text ?? ""
                let weight = weightTextField.text ?? ""
                
                if let weight = Int16(weight), let pcItemList = self.pcItemList {
                    self.pcItemController.add(PCItemWithName: name, weight: weight, proCon: false, pcItemList: pcItemList)
                }
                
                DispatchQueue.main.async(execute: {
                    self.reloadTables()
                })
            }
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    var pros = [PCItem]()
    var cons = [PCItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prosTableView.estimatedRowHeight = 50
        prosTableView.rowHeight = UITableViewAutomaticDimension
        
        consTableView.estimatedRowHeight = 50
        consTableView.rowHeight = UITableViewAutomaticDimension
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
        
        title = pcItemList?.name

        reloadTables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadTables()
        
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let weightTextField = alertController.textFields?.last {
            if row != 0 {
                weightTextField.text = self.weightPickerData[row]
            } else {
                weightTextField.text = ""
            }
        }
    }
    

    func reloadWeights() {
        var proWeight: Int = 0
        for pro in pros {
            proWeight = proWeight + Int(pro.weight)
        }
        prosWeightTotalLabel.text = String(proWeight)
        
        
        var conWeight: Int = 0
        for con in cons {
            conWeight = conWeight + Int(con.weight)
        }
        consWeightTotalLabel.text = String(conWeight)
        
        if pros.count == 0 && cons.count == 0 {
            pcItemList?.weightPlusMinus = "-"
        } else {
            pcItemList?.weightPlusMinus = String(proWeight - conWeight)
        }
        
        PCItemListController.shared.saveToPersistentStorage()
        
        if proWeight > conWeight {
            prosWeightTotalLabel.textColor = #colorLiteral(red: 0, green: 0.5836070843, blue: 0.3329543817, alpha: 1)
            consWeightTotalLabel.textColor = #colorLiteral(red: 0.8588235294, green: 0.1416355417, blue: 0.06344364766, alpha: 1)
        } else if conWeight > proWeight {
            consWeightTotalLabel.textColor = #colorLiteral(red: 0, green: 0.5836070843, blue: 0.3329543817, alpha: 1)
            prosWeightTotalLabel.textColor = #colorLiteral(red: 0.8588235294, green: 0.1416355417, blue: 0.06344364766, alpha: 1)
        } else {
            consWeightTotalLabel.textColor = #colorLiteral(red: 1, green: 0.5564047739, blue: 0.01442946099, alpha: 1)
            prosWeightTotalLabel.textColor = #colorLiteral(red: 1, green: 0.5564047739, blue: 0.01442946099, alpha: 1)
        }

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == prosTableView {
            return self.pros.count + 1
        } else {
            return cons.count + 1
        }
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var pro: PCItem?
        var con: PCItem?
//        var name: String?
//        var weight: String?
        
        

        if tableView == prosTableView {
            
            if indexPath.row == (pros.count) {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "addProCell", for: indexPath) as? AddNewTableViewCell else { return AddNewTableViewCell() }
                
                cell.delegate = self
                cell.setAddProButtonProperties()
                
                return cell
            }
            
            pro = pros[indexPath.row]
            
        } else {
            
            if indexPath.row == (cons.count) {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "addConCell", for: indexPath) as? AddNewTableViewCell else { return AddNewTableViewCell() }
                
                cell.delegate = self
                cell.setAddConButtonProperties()
                
                return cell
            }
            
            con = cons[indexPath.row]

        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PCItemTableViewCell else { return PCItemTableViewCell() }
        
        guard let pcItem = pro ?? con else { return PCItemTableViewCell() }
        
        
        
        cell.update(withItem: pcItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == prosTableView {
                let pcItem = pros[indexPath.row]
                pcItemController.delete(pcItem: pcItem)
                pros.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
               
                reloadWeights()
                
            } else {
                let pcItem = cons[indexPath.row]
                pcItemController.delete(pcItem: pcItem)
                cons.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
               
                reloadWeights()
            }
        }
    }


}





