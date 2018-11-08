//
//  BasicContractInfo.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 8/27/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class BasicContractInfoVC: UIViewController {

    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var contractNameTextField: TextField!
    @IBOutlet weak var buyerEmailTextField: TextField!
    @IBOutlet weak var cargoTypeTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialValues()
    }
    
    // Depending on if we are creating a new contract or not, either load up the values and show or fill in from pre-displayed text
    private func setInitialValues() {
        if (CurrentContract.shared.owner == "") {
            CurrentContract.shared.owner = Users.shared.currentUser
        }
        
        if (CurrentContract.shared.contractName == "") {
            CurrentContract.shared.contractName = contractNameTextField.text!
            screenTitle.text = "New Contract"
        } else {
            contractNameTextField.text! = CurrentContract.shared.contractName
            screenTitle.text = "Verify/Edit Contract"
        }
        
        if (CurrentContract.shared.otherPartyEmail == "") {
            CurrentContract.shared.otherPartyEmail = buyerEmailTextField.text!
        } else {
            buyerEmailTextField.text! = CurrentContract.shared.otherPartyEmail
        }
        
        if (CurrentContract.shared.description == "") {
            CurrentContract.shared.description = cargoTypeTextField.text!
        } else {
            cargoTypeTextField.text! = CurrentContract.shared.description
        }
    }
    
    private func isTextFieldsEmpty() -> Bool {
        if let contractNameText = contractNameTextField.text,
            let buyerEmailText = buyerEmailTextField.text, let cargoTypeText = cargoTypeTextField.text {
            
            let dialogUtility = DialogUtility()
            if contractNameText.isEmpty {
                dialogUtility.displayMyAlertMessage(vc: self, userMessage: "Please enter a contract name")
                return true
            }
            
            if buyerEmailText.isEmpty {
                dialogUtility.displayMyAlertMessage(vc: self, userMessage: "Please enter a buyer email")
                return true
            }
            
            if cargoTypeText.isEmpty {
                dialogUtility.displayMyAlertMessage(vc: self, userMessage: "Please enter a cargo type")
                return true
            }
        }
        
        return false
    }
    
    @IBAction func continueButton(_ sender: Any) {
        if (isTextFieldsEmpty()) {
            return
        } else {
            CurrentContract.shared.contractName = contractNameTextField.text!
            CurrentContract.shared.otherPartyEmail = buyerEmailTextField.text!
            CurrentContract.shared.description = cargoTypeTextField.text!
            
            // get parent view controller
            let parentVC = self.parent as! CreateContractVC
            
            // change page of PageViewController
            let nextPage = [parentVC.pages[1]]
            parentVC.setViewControllers(nextPage, direction: .forward, animated: true, completion: nil)
        }
    }
}
