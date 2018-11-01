//
//  ContractDB.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 11/1/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation

struct ContractDB: Decodable {
    var contractName: String
    var deadline: Int
    var depositLimit: Double
    var depositorAddress: String
    var depositorEmail: String
    var depositorName: String
    var description: String
    var maxTemperature: Double
    var minTemperature: Double
    var otherPartyAddress: String
    var otherPartyEmail: String
    var otherPartyName: String
    var _id: Int
    var status: Int
    var cargoValue: Double
}

struct Contracts: Decodable {
    var items: [ContractDB]
}

enum ContractStatus {
    case NOT_RUNNING
    case RUNNING
    case FAILED
    case COMPLETED
}
