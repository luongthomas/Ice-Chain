//
//  BasicContractInfo.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 8/27/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class BasicContractInfoVC: UIViewController {

    @IBOutlet weak var contractNameTextField: TextField!
    @IBOutlet weak var buyerEmailTextField: TextField!
    @IBOutlet weak var cargoTypeTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func continueButton(_ sender: Any) {
        
        if (isTextFieldsEmpty()) {
            return
        } else {
            Contract.shared.name = contractNameTextField.text!
            Contract.shared.buyerEmail = buyerEmailTextField.text!
            Contract.shared.cargoType = cargoTypeTextField.text!
        
            // get parent view controller
            let parentVC = self.parent as! CreateContractVC
            
            // change page of PageViewController
            let nextPage = [parentVC.pages[1]]
            parentVC.setViewControllers(nextPage, direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    func isTextFieldsEmpty() -> Bool {
        if let contractNameText = contractNameTextField.text,
            let buyerEmailText = buyerEmailTextField.text, let cargoTypeText = cargoTypeTextField.text {
            
            if contractNameText.isEmpty {
                displayMyAlertMessage (userMessage: "Please enter a contract name")
                return true
            }
            
            if buyerEmailText.isEmpty {
                displayMyAlertMessage (userMessage: "Please enter a buyer email")
                return true
            }
            
            if cargoTypeText.isEmpty {
                displayMyAlertMessage (userMessage: "Please enter a cargo type")
                return true
            }
        }
        
        return false
    }
    
    
    func displayMyAlertMessage(userMessage:String){
        let alert = UIAlertController(title: "Hold on there", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
