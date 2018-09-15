//
//  ConfirmContractVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/10/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class DisplayContractVC: UIViewController {
    
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
    
    
    var contract = Contract.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateString = dateFormatter.string(from: contract.deadline)

        let formattedDate = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateFormatString = dateFormatter.string(from: formattedDate!)

        contractName.text = contract.name
        buyerEmail.text = contract.buyerEmail
        cargoType.text = contract.cargoType
        minTemp.text = "\(contract.tempMin) C"
        maxTemp.text = "\(contract.tempMax) C"
        deadlineDate.text = "\(dateFormatString)"
        cargoValue.text = "\(contract.cargoValue) USD"
        depositor.text = contract.depositor.rawValue
        depositRate.text = "\(contract.depositRate)"
        owner.text = contract.owner.rawValue
    }
    
    @IBAction func confirmContract(_ sender: Any) {
        
        print("Confirming Contract")
    }
    
    
    
    
    
    
    
    
    
    
}
