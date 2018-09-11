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
    var savedCargoValue = 10000.0
    var savedDepositRate = 50.0

    
    @IBAction func SliderValueChanged(_ sender: UISlider) {
        savedDepositRate = Double(Int(sender.value))
        
        guard let titleLabel = depositRateDialog.titleLabel else { return }
        guard var _ = titleLabel.text else { return }
        
        let percentage = String(format: "The value is:%i",Int(sender.value))
        guard let _ = Double(percentage) else { return }
        
        depositRateDialog.setTitle(percentage, for: .normal)
        
        calculateDepositRateAndSetText()
    }
    
    @IBAction func ringVolumeSliderChange(_ sender: UISlider) {
        print(Int(sender.value))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(setAmountDismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        depositRateDialog.contentHorizontalAlignment = .center
        setCargoValueFromTextField()
        calculateDepositRateAndSetText()
    }
    
    func setCargoValueFromTextField() {
        guard let valueText = cargoValueTextField.text else { return }
        guard let cargoValue = Double(valueText) else { return }
        Contract.shared.cargoValue = cargoValue
        savedCargoValue = cargoValue
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
        
        depositRateLabel.text = depositRateText
        depositRateDialog.setTitle(infoText, for: .normal)
    }
    
    

}


