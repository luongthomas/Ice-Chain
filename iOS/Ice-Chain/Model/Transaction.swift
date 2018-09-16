//
//  Transaction.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/15/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation

struct TransactionResponse: Codable {
    var result : TransactionResult
    var id : String
    var error : String?
}

struct TransactionResult: Codable {
    let txid : String
    let sender : String
    let hash160 : String
    let address : String?
}

