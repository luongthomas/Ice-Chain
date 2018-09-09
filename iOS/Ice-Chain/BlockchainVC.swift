//
//  BlockchainVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 8/26/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit
import Alamofire


class BlockchainVC: UIViewController {

    let networkUtility = NetworkUtility()
    
    @IBAction func blockchainBtn(_ sender: Any) {
        networkUtility.communicateWithBlockchain()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    

}
