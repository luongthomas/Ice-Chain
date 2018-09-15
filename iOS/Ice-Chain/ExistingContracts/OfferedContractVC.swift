//
//  OfferedContractVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/14/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class OfferedContractVC: UIViewController {
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var cargoType: UILabel!
    
    var contract = Contract.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        status.text = contract.status.rawValue
        role.text = "You Are \(contract.owner.rawValue)"
        email.text = contract.buyerEmail
        cargoType.text = contract.cargoType
    }

}
