//
//  DeadlineVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/9/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class DeadlineVC: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func continueButton(_ sender: Any) {
        // Set contract Date
        CurrentContract.shared.deadline = Double(datePicker.date.timeIntervalSince1970)

        // get parent view controller
        let parentVC = self.parent as! CreateContractVC

        // change page of PageViewController
        let nextPage = [parentVC.pages[3]]
        parentVC.setViewControllers(nextPage, direction: .forward, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDate = Date()
        datePicker.minimumDate = currentDate
    }
}
