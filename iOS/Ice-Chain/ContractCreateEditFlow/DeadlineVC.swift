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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialValues()
    }
    
    private func setInitialValues() {
        let today = Date()
        datePicker.minimumDate = today
        
        if (CurrentContract.shared.deadline == 0.0) {
            datePicker.date = today
        } else {
            let unixTimestamp = CurrentContract.shared.deadline
            let date = Date(timeIntervalSince1970: unixTimestamp)
            datePicker.date = date
        }
    }
    
    @IBAction func continueButton(_ sender: Any) {
        // Set contract Date
        CurrentContract.shared.deadline = Double(datePicker.date.timeIntervalSince1970)

        // get parent view controller
        let parentVC = self.parent as! CreateContractVC

        // change page of PageViewController
        let nextPage = [parentVC.pages[3]]
        parentVC.setViewControllers(nextPage, direction: .forward, animated: true, completion: nil)
    }
}
