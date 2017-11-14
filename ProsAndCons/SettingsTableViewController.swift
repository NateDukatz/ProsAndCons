//
//  SettingsTableViewController.swift
//  ProsAndCons
//
//  Created by Nate Dukatz on 10/17/17.
//  Copyright © 2017 NateDukatz. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    static let shared = SettingsTableViewController()
    
    var alternateWeightSelected: Bool = true
    @IBOutlet weak var alternateWeightSwitch: UISwitch!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSettings()
        alternateWeightSwitch.isOn = alternateWeightSelected
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    func loadSettings() {
        
        alternateWeightSelected = UserDefaults.standard.bool(forKey: "altWeightSelected")

    }

    func toggleAltWeight() {
        alternateWeightSelected = alternateWeightSwitch.isOn
        UserDefaults.standard.set(alternateWeightSelected, forKey: "altWeightSelected")
        
    }

    @IBAction func switchValueChanged(_ sender: Any) {
        toggleAltWeight()
    }
    
    // MARK: - Table view data source


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
