//
//  ConfirmContractVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/14/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class RunningContractVC: UIViewController {
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var cargoType: UILabel!
    @IBOutlet weak var tempRange: UILabel!
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var deposit: UILabel!
    
    var contract = Contract.running
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateString = dateFormatter.string(from: contract.deadline)

        let formattedDate = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateFormatString = dateFormatter.string(from: formattedDate!)
        
        let depositDollars = NumberFormatter.localizedString(from: NSNumber(value: contract.deposit), number: NumberFormatter.Style.decimal)
        
        let valueDollars = NumberFormatter.localizedString(from: NSNumber(value: contract.cargoValue), number: NumberFormatter.Style.decimal)
            

        status.text = contract.status.rawValue
        role.text = "You Are \(contract.owner.rawValue)"
        email.text = contract.buyerEmail
        cargoType.text = contract.cargoType
        tempRange.text = "From \(contract.tempMin) C to \(contract.tempMax) C"
        deadline.text = dateFormatString
        value.text = "\(valueDollars) USD"
        
        deposit.text = "\(depositDollars) USD"
    }
    
    @IBAction func confirmContract(_ sender: Any) {
        
        print("Confirming Contract")
    }
    
    
    
    
    
    
    
    
    
    
}