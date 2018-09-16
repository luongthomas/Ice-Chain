//
//  ContractEditDeployVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/15/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit


class ContractEditDeployVC: UIViewController {
    
    @IBOutlet weak var txidLabel: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var doneButton: UIButton!
    var contractDeployed = false
    var depositConfirmed = false
    
    var timer = Timer()
    
    @IBOutlet weak var depositButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        depositButton.isEnabled = false
        depositButton.isHidden = true
        doneButton.isEnabled = false
        doneButton.isHidden = true
        
        scheduledTimerWithTimeInterval()
        
        deploy()
    }
    
    func deploy() {
        let contract = Contract.shared
        contract.status = .RUNNING
        NetworkUtility().deployContract()
    }
    
    func scheduledTimerWithTimeInterval() {
        // Change delay in seconds here
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(confirmContract), userInfo: nil, repeats: true)
    }
    
    @IBAction func depositMoney(_ sender: Any) {
        spinner.isHidden = false
        status.text = "Verifying Deposit..."
        depositButton.isEnabled = false
        depositButton.isHidden = true
        doneButton.isHidden = true
        doneButton.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(confirmDeposit), userInfo: nil, repeats: true)
        NetworkUtility().depositMoney()
    }
    
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func confirmContract() {
        guard let txid = Deployed.shared.transactionIds.last else { return }
        txidLabel.text = txid
        print("Checking confirmations")
        NetworkUtility().checkConfirmation(txid: txid) { (isConfirmed) in
            print("Confirmations: \(isConfirmed)")
            
            if isConfirmed {
                self.status.text = "Contract Uploaded!"
                self.depositButton.isEnabled = true
                self.depositButton.isHidden = false
                self.spinner.isHidden = true
                self.contractDeployed = true
                self.stopTimer()
            } else {
                print("Not done")
            }
        }
    }
    
    @objc func confirmDeposit() {
        guard let txid = Deployed.shared.transactionIds.last else { return }
        txidLabel.text = txid
        print("Checking confirmations")
        NetworkUtility().checkConfirmation(txid: txid) { (isConfirmed) in
            print("Confirmations: \(isConfirmed)")
            
            if isConfirmed {
                self.status.text = "Deposit Sent!"
                self.doneButton.isEnabled = true
                self.doneButton.isHidden = false
                self.depositButton.isEnabled = false
                self.depositButton.isHidden = true
                self.spinner.isHidden = true
                self.depositConfirmed = true
                self.stopTimer()
            } else {
                print("Not done")
            }
        }
    }

}
