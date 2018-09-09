//
//  Accounts.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/9/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation

struct AccountBalance: Codable {
    var result : AccountBalanceInfo
    var id : String
    var error : String?

}

struct AccountBalanceInfo: Codable {
    let buyer : Double
    let seller : Double
}
