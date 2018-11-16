//
//  Txid.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/16/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation


//"result": {
//    "amount": 0,
//    "fee": -2.225,
//    "confirmations": 324,
//    "blockhash": "48c007f57563ece7bde66381f90e4b8aaf5d2029e4c8a1f2659363bcc88f129d",
//    "blockindex": 2,
//    "blocktime": 1537064176,
//    "txid": "d743832bb2eabd172cbd0bbd4526d4cb0b6d56f2e7cac1ba5b5468d700b43152",
//    "walletconflicts": [],
//    "time": 1537064174,
//    "timereceived": 1537064174,
//    "bip125-replaceable": "no",

struct Txid: Codable {
    var result : TxidResult
}

struct TxidResult: Codable {
    let amount : Double
    let fee : Double
    let confirmations : Int
    let txid : String
}

struct Confirmations: Codable {
    var value : Int
}
