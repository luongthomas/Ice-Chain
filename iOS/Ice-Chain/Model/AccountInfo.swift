//
//  Balance.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 11/7/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation

struct AccountInfo: Decodable {
    var balance: Double = 0.0
    var address: String = ""
}
