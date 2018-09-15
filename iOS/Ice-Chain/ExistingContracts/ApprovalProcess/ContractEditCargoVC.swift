//
//  ContractEditCargoVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/14/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit


class ContractEditCargoVC: UIViewController {
    
    @IBOutlet weak var value: TextField!
    @IBOutlet weak var party: Button!
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var deposit: Button!
    
    let contract = Contract.shared
    // Temp variable to set the text and calculate values
    var savedCargoValue = 100.0
    var savedDepositRate = 67.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        value.text = "\(contract.cargoValue)"
        let partyText = "Depositor: \(contract.depositor.rawValue)"
        party.setTitle(partyText, for: .normal)
        rateSlider.value = Float(contract.depositRate)
        rate.text = "Deposit Rate is \(contract.depositRate)%"
        
        setCargoValueFromTextField()
        calculateDepositRateAndSetText()
    }
    
    
    @IBAction func rateChange(_ sender: UISlider) {
        savedDepositRate = Double(Int(sender.value))
        Contract.shared.depositRate = savedDepositRate
        calculateDepositRateAndSetText()
        
    }
    
    
    func setCargoValueFromTextField() {
        guard let valueText = value.text else { return }
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
        let rateValue = savedDepositRate
        
        let depositRateText = "Deposit rate is \(rateValue)%"
        
        // Limit to two decimal places
        let depositAmountUSD = amount * (rateValue / 100.0)
        let roundedUSD = (depositAmountUSD * 100).rounded() / 100
        let depositAmountQtum = depositAmountUSD / qtumPrice
        let roundedQtum = (depositAmountQtum * 100).rounded() / 100
        
        
        let infoText = "Deposit is equal to \(roundedUSD) USD or\n\(roundedQtum) QTUM"
        
        Contract.shared.deposit = depositAmountUSD
        rate.text = depositRateText
        deposit.setTitle(infoText, for: .normal)
    }
    
}
