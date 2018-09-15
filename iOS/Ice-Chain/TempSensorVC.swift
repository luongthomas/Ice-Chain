//
//  TempSensorVC.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/14/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import UIKit
import RxBluetoothKit
import CoreBluetooth
import RxSwift

class TempSensorVC: UIViewController {
    
    @IBOutlet weak var temp: UILabel!
    
    
    let manager = CentralManager(queue: .main)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let serviceId = [CBUUID(string: "FFE0"), CBUUID(string: "FFE1")]
        
        let state: BluetoothState = self.manager.state
        
        
        
    }
    
    
}
