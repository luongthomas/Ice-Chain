//
//  Deployed.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/15/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation

struct Deployed {
    
    var transactionIds = [String]()
    var contractAddresses = [String]()
    
    init() {
        
    }
    
    static var shared = Deployed()
}
