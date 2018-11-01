//
//  ViewContractTemplateVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 10/31/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class ViewContractTemplateVC: UIViewController {
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var role: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var cargoType: UILabel!
    @IBOutlet weak var tempRange: UILabel!
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var deposit: UILabel!
    
    var contract: ContractDB?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(contract!.deadline)))
        
        let formattedDate = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateFormatString = dateFormatter.string(from: formattedDate!)
        
        let depositDollars = NumberFormatter.localizedString(from: NSNumber(value: contract!.depositLimit), number: NumberFormatter.Style.decimal)
        
        let valueDollars = NumberFormatter.localizedString(from: NSNumber(value: contract!.cargoValue), number: NumberFormatter.Style.decimal)
        
        if Users.shared.currentUser == "Seller" {
            role.text = "You Are Seller"
        } else {
            role.text = "You Are Buyer"
        }
        let ON_APPROVAL = 0
        let RUNNING = 1
        let FAILED = 2
        let COMPLETED = 3
        
        switch contract!.status {
        case ON_APPROVAL:
            status.text = "On Approval"
        case RUNNING:
            status.text = "Running"
        case FAILED:
            status.text = "Failed"
        case COMPLETED:
            status.text = "Completed"
        default:
            status.text = "Unknown status"
        }
        
        email.text = contract!.depositorEmail
        cargoType.text = contract!.description
        tempRange.text = "From \(contract!.minTemperature) C to \(contract!.maxTemperature) C"
        deadline.text = dateFormatString
        value.text = "\(valueDollars) USD"
        deposit.text = "\(depositDollars) USD"
    }
    
    @IBAction func confirmContract(_ sender: Any) {
        
        print("Confirming Contract")
    }
    
    
    
    
    
    
    
    
    
    
}
