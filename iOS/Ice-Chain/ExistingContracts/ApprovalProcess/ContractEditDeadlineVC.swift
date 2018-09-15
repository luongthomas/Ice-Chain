//
//  ContractEditDeadlineVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/15/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit


class ContractEditDeadlineVC: UIViewController {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let contract = Contract.running
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.date = contract.deadline
    }
    
}
