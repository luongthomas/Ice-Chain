//
//  TemperatureRangeVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/9/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class TemperatureRangeVC: UIViewController, UITextFieldDelegate {
    
    // TODO: Add label to top of screen to show current selection

    @IBOutlet weak var minTempRangeTextField: TextField!
    @IBOutlet weak var maxTempRangeTextField: TextField!
    @IBOutlet weak var prechosenOptions: UIStackView!
    @IBOutlet weak var vaccinesBtn: Button!
    @IBOutlet weak var otherRangeBtn: Button!
    
    let niceBlue = UIColor(red: 66/255, green: 137/255, blue: 247/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        setInitialValues()
    }
    
    private func setInitialValues() {
        if (CurrentContract.shared.maxTemperature == 0 && CurrentContract.shared.minTemperature == 0) {
            if let btn = vaccinesBtn {
                btn.sendActions(for: .touchUpInside)
            }
        } else {
            if let btn = otherRangeBtn {
                btn.backgroundColor = niceBlue
                btn.setTitleColor(.white, for: .normal)
                btn.sendActions(for: .touchUpInside)
            }
            
            if let minTemp = minTempRangeTextField {
                minTemp.text = "\(CurrentContract.shared.minTemperature)"
            }
            
            if let maxTemp = maxTempRangeTextField {
                maxTemp.text = "\(CurrentContract.shared.maxTemperature)"
            }
        }
    }
    
    private func resetAllBtnColors() {
        for case let button as UIButton in self.prechosenOptions.subviews {
            button.backgroundColor = .white
            button.setTitleColor(niceBlue, for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func tempSelect(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        // Only do reset colors for the buttons that have preselected temp ranges
        if (0...6).contains(button.tag) {
            resetAllBtnColors()
            button.backgroundColor = niceBlue
            button.setTitleColor(.white, for: .normal)
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
            // Custom Temp Range Open Dialog
            break
        case 7:
            // Custom Temp Range values chosen
            customTempRangeSelected()
        default:
            print("Selection")
            return
        }
    }
    
    private func customTempRangeSelected() {
        if let minText = minTempRangeTextField.text,
            let maxText = maxTempRangeTextField.text {
            let dialogUtility = DialogUtility()
            
            if minText.isEmpty {
                dialogUtility.displayMyAlertMessage(vc: self, userMessage: "Enter value for minimum temperature.")
            } else if maxText.isEmpty {
                dialogUtility.displayMyAlertMessage(vc: self, userMessage: "Enter value for maximum temperature.")
            } else {
                if let min = Double(minText), let max = Double(maxText) {
                
                    if (min > max) {
                        dialogUtility.displayMyAlertMessage(vc: self, userMessage: "Minimum temperature must be smaller than Maximum")
                    } else {
                        setTempRangeFor(min: min, max: max)
                    }
                } else {
                    dialogUtility.displayMyAlertMessage(vc: self, userMessage: "Enter only numerical values for temperatures")
                }
            }
        }
    }
    
    func setTempRangeFor(min: Double, max: Double) {
        CurrentContract.shared.maxTemperature = max
        CurrentContract.shared.minTemperature = min
    }
    
    @IBAction func unwindToGlobal(segue: UIStoryboardSegue) {}

    @IBAction func handleBackBtnPress(_ sender: Any) {
        // get parent view controller
        let parentVC = self.parent as! CreateContractVC
        
        // change page of PageViewController
        let prevPage = [parentVC.pages[0]]
        parentVC.setViewControllers(prevPage, direction: .reverse, animated: true, completion: nil)
    }
    
    @IBAction func handleContinue(_ sender: Any) {
        // get parent view controller
        let parentVC = self.parent as! CreateContractVC
        
        // change page of PageViewController
        let nextPage = [parentVC.pages[2]]
        parentVC.setViewControllers(nextPage, direction: .forward, animated: true, completion: nil)
    }
}
