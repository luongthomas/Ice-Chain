//
//  CargoDepositorVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/9/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

class CargoDepositorVC: UIViewController {
    
    @IBOutlet weak var vendorBtn: Button!
    
    let niceBlue = UIColor(red: 66/255, green: 137/255, blue: 247/255, alpha: 1)
    
    func resetAllBtnColors() {
        for case let button as UIButton in self.view.subviews {
            button.backgroundColor = .white
            button.setTitleColor(niceBlue, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupDefaultTemp() {
        if let btn = vendorBtn {
            btn.sendActions(for: .touchUpInside)
        }
    }
    
    @IBAction func selectDepositor(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        // Only do reset colors for the buttons that have preselected temp ranges
        if (0...1).contains(button.tag) {
            resetAllBtnColors()
            button.backgroundColor = niceBlue
            button.setTitleColor(.white, for: .normal)
        }
        
        switch button.tag {
        case 0:
            CurrentContract.shared.depositorName = "Seller"
            CurrentContract.shared.depositorEmail = "Seller@gmail.com"
            CurrentContract.shared.otherPartyName = "Seller"
            CurrentContract.shared.otherPartyEmail = "Seller@gmail.com"
            // Post a notification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "depositorSelected"), object: nil)
            break
        case 1:
            CurrentContract.shared.depositorName = "Buyer"
            CurrentContract.shared.depositorEmail = "Buyer@gmail.com"
            CurrentContract.shared.otherPartyName = "Buyer"
            CurrentContract.shared.otherPartyEmail = "Buyer@gmail.com"
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "depositorSelected"), object: nil)
            break
        default:
            print("Unknown selection")
            return
        }
    }
    
    @IBAction func popOffVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToGlobal(segue: UIStoryboardSegue) {}
}
