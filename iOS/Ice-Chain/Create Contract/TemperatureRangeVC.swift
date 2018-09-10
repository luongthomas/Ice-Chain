//
//  TemperatureRangeVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/9/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class TemperatureRangeVC: UIViewController, UITextFieldDelegate {

    var contract = Contract()

    @IBOutlet weak var minTempRangeTextField: TextField!
    @IBOutlet weak var maxTempRangeTextField: TextField!
    
    
    @IBAction func tempSelect(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        switch button.tag {
        case 0:
            // Flowers
            setTempRangeFor(min: 1.0, max: 8.0)
            break
        case 1:
            // Deep Freeze
            setTempRangeFor(min: -10.0, max: -18.0)
            break
        case 2:
            // Vaccines
            setTempRangeFor(min: 2.0, max: 8.0)
            break
        case 3:
            // Creamy Cakes
            setTempRangeFor(min: -2.0, max: 2.0)
            break
        case 4:
            // Alcoholic Drinks
            setTempRangeFor(min: 10.0, max: 12.0)
            break
        case 5:
            // Perishable Goods
            setTempRangeFor(min: -5.0, max: -1.0)
        case 6:
            // Custom Temp Range
            customTempRangeSelected()
            break
        default:
            print("Selection")
            return
        }
        
    }
    
    func customTempRangeSelected() {
        if let minText = minTempRangeTextField.text,
            let maxText = maxTempRangeTextField.text {
            if minText.isEmpty {
                displayMyAlertMessage(userMessage: "Enter value for minimum temperature.")
            } else if maxText.isEmpty {
                displayMyAlertMessage(userMessage: "Enter value for maximum temperature.")
            } else {
                if let min = Double(minText), let max = Double(maxText) {
                
                    if (min > max) {
                        displayMyAlertMessage(userMessage: "Minimum temperature must be smaller than Maximum")
                    } else {
                        setTempRangeFor(min: min, max: max)
                    }
                } else {
                    displayMyAlertMessage(userMessage: "Enter only numerical values for temperatures")
                }
                
                
            }
        }
    }
    
    
    func setTempRangeFor(min: Double, max: Double) {
        self.contract.tempMin = min
        self.contract.tempMax = max
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
    func displayMyAlertMessage(userMessage:String){
        let alert = UIAlertController(title: "Hold on there", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToGlobal(segue: UIStoryboardSegue) {
        
    }
}
