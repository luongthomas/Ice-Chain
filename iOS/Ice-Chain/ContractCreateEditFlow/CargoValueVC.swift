//
//  CargoValueVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/9/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class CargoValueVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var depositorPartyButton: Button!
    
    // TODO: Rename to Calculated
    @IBOutlet weak var depositRateDialog: Button!
    @IBOutlet weak var cargoValueTextField: TextField!
    @IBOutlet weak var depositRateLabel: UILabel!
    
    // Temp variable to set the text and calculate values
    var savedCargoValue = 100.0
    var savedDepositRate = 65.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(setAmountDismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        registerNotifications()
        calculateDepositRateAndSetText()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDepositPartyLabel(notification:)), name: NSNotification.Name(rawValue: "depositorSelected"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (CurrentContract.shared.depositorName != "") {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "depositorSelected"), object: nil)
        }
        
        setInitialValues()
    }
    
    private func setInitialValues() {
        let currentUser = Users.shared.currentUser
        if currentUser == "Seller" {
            CurrentContract.shared.owner = "Seller"
        } else if currentUser == "Buyer" {
            CurrentContract.shared.owner = "Buyer"
        } else {
            print("Unknown current user")
        }
        
        if (CurrentContract.shared.depositRate != 0.0) {
            savedDepositRate = CurrentContract.shared.depositRate
            depositRateLabel.text = "\(CurrentContract.shared.depositRate)"
        }
        
        if (CurrentContract.shared.cargoValue != 0.0) {
            savedCargoValue = CurrentContract.shared.cargoValue
            cargoValueTextField.text = "\(CurrentContract.shared.cargoValue)"
        }
        
        calculateDepositRateAndSetText()
    }
    
    @IBAction func SliderValueChanged(_ sender: UISlider) {
        savedDepositRate = Double(Int(sender.value))
        CurrentContract.shared.depositRate = savedDepositRate
        calculateDepositRateAndSetText()
    }
    
    @objc func updateDepositPartyLabel(notification: NSNotification) {
        if CurrentContract.shared.depositorName != "" {
            let depositor = CurrentContract.shared.depositorName
            depositorPartyButton.setTitle(depositor, for: .normal)
        }
    }
    
    func setCargoValueFromTextField() {
        guard let valueText = cargoValueTextField.text else { return }
        guard let cargoValue = Double(valueText) else { return }
        savedCargoValue = cargoValue
        CurrentContract.shared.cargoValue = savedCargoValue
    }
    
    @objc func setAmountDismissKeyboard(sender: Any) {
        setCargoValueFromTextField()
        self.view.endEditing(true)
        calculateDepositRateAndSetText()
    }

    func calculateDepositRateAndSetText() {
        let qtumPrice = 3.5
        let amount = savedCargoValue
        let rate = savedDepositRate
        
        let depositRateText = "Deposit rate is \(rate)%"
        
        // Limit to two decimal places
        let depositAmountUSD = amount * (rate / 100.0)
        let roundedUSD = (depositAmountUSD * 100).rounded() / 100
        let depositAmountQtum = depositAmountUSD / qtumPrice
        let roundedQtum = (depositAmountQtum * 100).rounded() / 100
        
        let infoText = "Deposit is equal to \(roundedUSD) USD or\n\(roundedQtum) QTUM"
        
        CurrentContract.shared.depositLimit = roundedQtum
        CurrentContract.shared.depositRate = rate
        depositRateLabel.text = depositRateText
        depositRateDialog.setTitle(infoText, for: .normal)
    }
    
    @IBAction func handleBackBtnPress(_ sender: Any) {
        // get parent view controller
        let parentVC = self.parent as! CreateContractVC
        
        // change page of PageViewController
        let prevPage = [parentVC.pages[2]]
        parentVC.setViewControllers(prevPage, direction: .reverse, animated: true, completion: nil)
    }
    
    @IBAction func handleContinue(_ sender: Any) {
        if (CurrentContract.shared.depositorName != "" && CurrentContract.shared.cargoValue > 0) {
            let parentVC = self.parent as! CreateContractVC
            
            // change page of PageViewController
            let nextPage = [parentVC.pages[4]]
            parentVC.setViewControllers(nextPage, direction: .forward, animated: true, completion: nil)
        }
    }
}
