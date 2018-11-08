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
    @IBOutlet weak var depositValueQtum: UILabel!
    
    @IBOutlet weak var actionBtn: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let unixTimestamp = CurrentContract.shared.deadline
        let date = Date(timeIntervalSince1970: unixTimestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateFormatString = dateFormatter.string(from: date)

        contractName.text = CurrentContract.shared.contractName
        buyerEmail.text = CurrentContract.shared.otherPartyEmail
        cargoType.text = CurrentContract.shared.description
        minTemp.text = "\(CurrentContract.shared.minTemperature) C"
        maxTemp.text = "\(CurrentContract.shared.maxTemperature) C"
        deadlineDate.text = "\(dateFormatString)"
        cargoValue.text = "\(CurrentContract.shared.cargoValue) USD"
        depositor.text = CurrentContract.shared.depositorName
        depositRate.text = "\(CurrentContract.shared.depositRate) %"
        depositValueQtum.text = "\(CurrentContract.shared.depositLimit) QTUM"
        owner.text = CurrentContract.shared.owner
        
        if (CurrentContract.shared._id == "") {
            actionBtn.setTitle("Offer Contract", for:  .normal)
        } else {
            if (Users.shared.currentUser == CurrentContract.shared.depositorName) {
                actionBtn.setTitle("Deposit \(CurrentContract.shared.depositLimit) QTUM", for:  .normal)
            } else {
                actionBtn.setTitle("Done", for:  .normal)
            }
        }
    }
    
    @IBAction func confirmContract(_ sender: Any) {
        if (actionBtn.titleLabel!.text == "Done" || actionBtn.titleLabel!.text == "Go Back") {
            dismiss(animated: true, completion: nil)
            return
        }
        
        if (actionBtn.titleLabel!.text == "Offer Contract") {
            // Creating new Contract and submitting to DB
            CurrentContract.shared.status = Constants().ON_APPROVAL
            print("Confirming Contract")
            
            NetworkUtility().sendNewContractToDatabase(contract: CurrentContract.shared) { (objId, err) in
                if let err = err {
                    print(err)
                    DialogUtility().displayMyAlertMessage(vc: self, userMessage: "\(err)")
                }
                if let id = objId {
                    print(id)
                }
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        if (CurrentContract.shared._id != "") {
            // Contract in DB but not on Blockchain yet
            var balance = 0.0
            if (Users.shared.currentUser == "Buyer") {
                balance = Users.shared.buyerBalance
            } else {
                balance = Users.shared.sellerBalance
            }
            if (balance < CurrentContract.shared.depositLimit) {
                DialogUtility().displayMyAlertMessage(vc: self, userMessage: "Your balance \(balance) QTUM is not enough to cover the deposit")
                actionBtn.setTitle("Go Back", for: .normal)
            } else {
                // TODO: Send off to blockchain
                
                // TODO: Update database on status
                
                dismiss(animated: true, completion: nil)
                print("Deposit and Send to blockchain")
                return
            }
        }
    }
    
    @IBAction func unwindToGlobal(segue: UIStoryboardSegue) {}
}
