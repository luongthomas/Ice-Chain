//
//  DeadlineVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/9/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit


class DeadlineVC: UIViewController {
    
    var contract = Contract()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func continueButton(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        print(selectedDate)

        // Set contract Date
        contract.deadline = datePicker.date

        // get parent view controller
        let parentVC = self.parent as! CreateContractVC

        // change page of PageViewController
        let nextPage = [parentVC.pages[3]]
        parentVC.setViewControllers(nextPage, direction: .forward, animated: true, completion: nil)
    }
    
}
