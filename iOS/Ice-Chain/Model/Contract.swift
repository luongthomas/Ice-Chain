//
//  Contract.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/9/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation



class Contract  {
    
    var name: String
    var buyerEmail: String
    var cargoType: String
    var tempMax: Double
    var tempMin: Double
    var deadline: Date
    var cargoValue: Double
    var depositor: CustomerType
    var depositRate: Double
    var owner: CustomerType
    var status: AgreementStatus
    
    init() {
        self.name = ""
        self.buyerEmail = ""
        self.cargoType = ""
        self.tempMax = 0.0
        self.tempMin = 0.0
        self.deadline = Date()
        self.cargoValue = 0.0
        self.depositor = CustomerType.NONE
        self.depositRate = 0.0
        self.owner = CustomerType.NONE
        self.status = AgreementStatus.NONE
    }
    
    func resetContract() {
        print("Contract reset")
        self.name = ""
        self.buyerEmail = ""
        self.cargoType = ""
        self.tempMax = 0.0
        self.tempMin = 0.0
        self.deadline = Date()
        self.cargoValue = 0.0
        self.depositor = CustomerType.NONE
        self.depositRate = 0.0
        self.owner = CustomerType.NONE
        self.status = AgreementStatus.NONE
    }
    
    static let sharedInstance: Contract = {
        let instance = Contract()
        return instance
    }()
    
    
}

enum AgreementStatus {
    case AGREED
    case DECLINED
    case OFFERED
    case NONE
}

enum CustomerType {
    case SELLER
    case BUYER
    case NONE
}
