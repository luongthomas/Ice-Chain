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
    var savedDepositRate = 67.0

    
    @IBAction func SliderValueChanged(_ sender: UISlider) {
        savedDepositRate = Double(Int(sender.value))
        Contract.shared.depositRate = savedDepositRate
        calculateDepositRateAndSetText()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(updateDepositPartyLabel(notification:)), name: NSNotification.Name(rawValue: "depositorSelected"), object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(setAmountDismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        depositRateDialog.contentHorizontalAlignment = .center
        setCargoValueFromTextField()
        calculateDepositRateAndSetText()
        
        
        // Default values
        Contract.shared.owner = .BUYER
        Contract.shared.depositor = .SELLER
        Contract.shared.depositRate = 67.0
        
    }
    
    @objc func updateDepositPartyLabel(notification: NSNotification) {
        if Contract.shared.depositor != .NONE {
            let depositor = Contract.shared.depositor.rawValue
            depositorPartyButton.setTitle(depositor, for: .normal)
        }
    }
    
    
    
    func setCargoValueFromTextField() {
        guard let valueText = cargoValueTextField.text else { return }
        guard let cargoValue = Double(valueText) else { return }
        savedCargoValue = cargoValue
        Contract.shared.cargoValue = savedCargoValue
    }
    
    @objc func setAmountDismissKeyboard(sender: Any) {
        setCargoValueFromTextField()
        self.view.endEditing(true)
        
        print("Cargo Value is \(Contract.shared.cargoValue)")
        
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
        
        Contract.shared.deposit = depositAmountUSD
        depositRateLabel.text = depositRateText
        depositRateDialog.setTitle(infoText, for: .normal)
    }

}


