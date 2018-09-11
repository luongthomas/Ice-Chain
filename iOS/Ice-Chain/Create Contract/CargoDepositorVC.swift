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
        if let btn = vendorBtn {
            // select default value
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
            Contract.shared.depositor = .SELLER
            break
        case 1:
            Contract.shared.depositor = .BUYER
            break
            
        default:
            print("Unknown selection")
            return
        }
        
    }
    
    
    @IBAction func popOffVC() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func unwindToGlobal(segue: UIStoryboardSegue) {
        
    }
}
