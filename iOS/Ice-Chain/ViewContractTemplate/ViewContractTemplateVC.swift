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
    @IBOutlet weak var actionButton: Button!
    
    var contract: ContractDB?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setStatusText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CurrentContract.shared = contract!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(contract!.deadline)))
        
        let formattedDate = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateFormatString = dateFormatter.string(from: formattedDate!)
        
        let depositQTUM = NumberFormatter.localizedString(from: NSNumber(value: contract!.depositLimit), number: NumberFormatter.Style.decimal)
        
        let valueDollars = NumberFormatter.localizedString(from: NSNumber(value: contract!.cargoValue), number: NumberFormatter.Style.decimal)
        
        let currentUser = Users.shared.currentUser
        if currentUser == "Seller" {
            role.text = "You Are Seller"
        } else {
            role.text = "You Are Buyer"
        }
        
        email.text = contract!.depositorEmail
        cargoType.text = contract!.description
        tempRange.text = "From \(contract!.minTemperature) C to \(contract!.maxTemperature) C"
        deadline.text = dateFormatString
        value.text = "\(valueDollars) USD"
        deposit.text = "\(depositQTUM) QTUM"
    }
    
    private func setStatusText() {
        let ON_APPROVAL = 0
        let RUNNING = 1
        let FAILED = 2
        let COMPLETED = 3
        
        let currentUser = Users.shared.currentUser
        guard var contract = contract else { return }
        contract = CurrentContract.shared
        
        switch contract.status {
        case ON_APPROVAL:
            status.text = "On Approval"
            if (currentUser == "Seller") {
                actionButton.setTitle("On the Buyer Approval", for: .normal)
                actionButton.isEnabled = false
            } else {
                actionButton.setTitle("Approve/Edit", for: .normal)
                actionButton.isEnabled = true
            }
        case RUNNING:
            status.text = "Running"
            actionButton.setTitle("Unload", for: .normal)
            if (currentUser == "Seller") {
                actionButton.isEnabled = false
            } else {
                actionButton.isEnabled = true
            }
        case FAILED:
            status.text = "Failed"
            actionButton.setTitle("Download Report", for: .normal)
        case COMPLETED:
            status.text = "Completed"
            actionButton.setTitle("Download Report", for: .normal)
        default:
            status.text = "Unknown status"
            actionButton.setTitle("Unknown Action", for: .normal)
        }
    }
    
    @IBAction func confirmContract(_ sender: Any) {
        // Different button texts will take the user to different screens
        
        // TODO: Approve/Edit
        if (actionButton.titleLabel?.text == "Approve/Edit") {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "contractFlowTemplate") as? CreateContractVC else { return }

            CurrentContract.shared = contract!
            self.present(vc, animated: true, completion: nil)
        }
        
        
        // TODO: Unload
        if (actionButton.titleLabel?.text == "Unload") {
            State.viewContractGraph = true
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "scanResultsVC") as! ScanResultsViewController
            self.present(vc, animated: true, completion: nil)
            
            // Scan results will put the data into the database, send it off to smart contract for verification
            
        }
        
        // TODO: Download Report
        
        
        
        print("Confirming Contract")
    }
}
