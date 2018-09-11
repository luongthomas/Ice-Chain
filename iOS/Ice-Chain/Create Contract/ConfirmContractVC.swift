//
//  ConfirmContractVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/10/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class ConfirmContractVC: UIViewController {
    
    @IBOutlet weak var contractName: UILabel!
    @IBOutlet weak var buyerEmail: UILabel!
    @IBOutlet weak var cargoType: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var deadlineDate: UILabel!
    @IBOutlet weak var cargoValue: UILabel!
    @IBOutlet weak var depositor: UILabel!
    @IBOutlet weak var depositRate: UILabel!
    @IBOutlet weak var owner: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateString = dateFormatter.string(from: Contract.shared.deadline)
        
        let formattedDate = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateFormatString = dateFormatter.string(from: formattedDate!)
        
        contractName.text = Contract.shared.name
        buyerEmail.text = Contract.shared.buyerEmail
        cargoType.text = Contract.shared.cargoType
        minTemp.text = "\(Contract.shared.tempMin) C"
        maxTemp.text = "\(Contract.shared.tempMax) C"
        deadlineDate.text = "\(dateFormatString)"
        cargoValue.text = "\(Contract.shared.cargoValue) USD"
        depositor.text = Contract.shared.depositor.rawValue
        depositRate.text = "\(Contract.shared.depositRate)"
        owner.text = Contract.shared.owner.rawValue
    }
    
    @IBAction func confirmContract(_ sender: Any) {
        
        print("Confirming Contract")
    }
    
    
    
    
    
    
    
    
    
    
}
