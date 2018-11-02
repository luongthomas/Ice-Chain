//
//  DialogUtility.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 11/2/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit

struct DialogUtility {
    
    func displayMyAlertMessage(vc: UIViewController, userMessage: String){
        let alert = UIAlertController(title: "Hold on there", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style:UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
