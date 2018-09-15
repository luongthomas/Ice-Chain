//
//  MyContractsVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/11/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit


class MyContractVC: UIViewController {
    
    @IBOutlet weak var vaccineStatusImg: UIImageView!
    @IBOutlet weak var vaccineStack: UIStackView!
    
    let contract = Contract.shared
    
    override func viewDidLoad() {
        if contract.status == .NONE {
            vaccineStack.alpha = 0
        } else {
            vaccineStack.alpha = 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        if contract.status == .EXECUTED {
            vaccineStatusImg.image = #imageLiteral(resourceName: "Check Button")
        } else if contract.status == .RUNNING {
            vaccineStatusImg.image = #imageLiteral(resourceName: "Check Mark")
        } else {
            vaccineStatusImg.image = #imageLiteral(resourceName: "filled_circle")
        }
        
        
    }
    
}
