//
//  BasicContractInfo.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 8/27/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class BasicContractInfoVC: UIViewController {

    var contract = Contract()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func unwindToGlobal(segue: UIStoryboardSegue) {
        // this may be blank
        
    }

    @IBAction func continueButton(_ sender: Any) {
        // get parent view controller
        let parentVC = self.parent as! CreateContractVC
        
        // change page of PageViewController
        parentVC.setViewControllers([parentVC.orderedViewControllers[1]], direction: .forward, animated: true, completion: nil)
    }
}
