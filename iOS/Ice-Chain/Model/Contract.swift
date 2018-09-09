//
//  Contract.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/9/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation

struct Contract {
    var name: String
    var buyerEmail: String
    var cargoType: String
    var tempMax: Double
    var tempMin: Double
    var deadline: Date
    var cargoValue: Double
    var depositor: depositor
    var depositRate: Double
    
}

enum depositor {
    case SELLER, BUYER
}
