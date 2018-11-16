//
//  ContractDB.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 11/1/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation

struct ContractDB: Decodable {
    var contractName: String = ""
    var deadline: Double = 0
    var depositLimit: Double = 0
    var depositorAddress: String = ""
    var depositorEmail: String = ""
    var depositorName: String = ""
    var description: String = ""
    var maxTemperature: Double = 0
    var minTemperature: Double = 0
    var otherPartyAddress: String  = ""
    var otherPartyEmail: String = ""
    var otherPartyName: String = ""
    var _id: String = ""
    var status: Int = 0
    var cargoValue: Double = 0
    var contractAddress: String  = ""
    var owner: String = ""
    var depositRate: Double = 0
    var txid: String = ""
    var temps: [Double] = [Double]()
    
    enum CodingKeys: String, CodingKey {
        case contractName = "contractName"
        case deadline = "deadline"
        case depositLimit = "depositLimit"
        case depositorAddress = "depositorAddress"
        case depositorEmail = "depositorEmail"
        case depositorName = "depositorName"
        case description = "description"
        case maxTemperature = "maxTemperature"
        case minTemperature = "minTemperature"
        case otherPartyAddress = "otherPartyAddress"
        case otherPartyName = "otherPartyName"
        case _id = "_id"
        case status = "status"
        case cargoValue = "cargoValue"
        case contractAddress = "contractAddress"
        case owner = "owner"
        case depositRate = "depositRate"
        case txid = "txid"
        case temps = "temps"
    }
    
    init() {
        contractName = ""
        deadline = 0
        depositLimit = 0
        depositorAddress = ""
        depositorEmail = ""
        depositorName = ""
        description = ""
        maxTemperature = 0
        minTemperature = 0
        otherPartyAddress  = ""
        otherPartyEmail = ""
        otherPartyName = ""
        _id = ""
        status = 0
        cargoValue = 0
        contractAddress  = ""
        owner = ""
        depositRate = 0
        txid = ""
        temps = [Double]()
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.contractName = try values.decode(String.self, forKey: .contractName)
        self.deadline = try values.decode(Double.self, forKey: .deadline)
        self.depositLimit = try values.decode(Double.self, forKey: .depositLimit)
        self.depositorEmail = try values.decode(String.self, forKey: .depositorEmail)
        self.depositorName = try values.decode(String.self, forKey: .depositorName)
        self.description = try values.decode(String.self, forKey: .description)
        self.maxTemperature = try values.decode(Double.self, forKey: .maxTemperature)
        self.minTemperature = try values.decode(Double.self, forKey: .minTemperature)
        self.otherPartyAddress = try values.decode(String.self, forKey: .otherPartyAddress)
        self.otherPartyName = try values.decode(String.self, forKey: .otherPartyName)
        self._id = try values.decode(String.self, forKey: ._id)
        self.status = try values.decode(Int.self, forKey: .status)
        self.cargoValue = try values.decode(Double.self, forKey: .cargoValue)
        self.contractAddress = try values.decode(String.self, forKey: .contractAddress)
        self.owner = try values.decode(String.self, forKey: .owner)
        self.depositRate = try values.decode(Double.self, forKey: .depositRate)
        self.txid = try values.decode(String.self, forKey: .txid)
        
        if values.contains(.temps) {
            self.temps = try [values.decodeIfPresent(Double.self, forKey: .temps)] as! [Double]
        } else {
            self.temps = [Double]()
        }
    }
}

class CurrentContract {
    static var shared = ContractDB()
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

struct ObjectId: Decodable {
    var objectId: String = ""
}
