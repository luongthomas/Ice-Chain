//
//  ContractEditDeployVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/15/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit


class ContractEditDeployVC: UIViewController {
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval()
    }
    
    @IBAction func deploy(_ sender: Any) {
        
        let contract = Contract.shared
        contract.status = .RUNNING
        
    }
    
    func scheduledTimerWithTimeInterval(){
        // Change delay in seconds here
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(done), userInfo: nil, repeats: true)
    }
    
    @objc func done() {
        spinner.isHidden = true
        status.text = "Completed!"
    }
}
