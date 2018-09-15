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
    var status: Status
    var deposit: Double
    
    private init(type: String) {
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
        self.status = .NONE
        self.deposit = 0.0
        
        if type == "running" {
            self.buyerEmail = "buyer@gmail.com"
            self.cargoType = "Bananas"
            self.tempMax = 21
            self.tempMin = 2
            self.deadline = Date(timeInterval: 1213112, since: Date())
            self.cargoValue = 100000
            self.depositor = .BUYER
            self.depositRate = 67
            self.owner = .SELLER
            self.status = .RUNNING
            self.deposit = 67000
            
        } else if type == "executed" {
            self.buyerEmail = "buyer@gmail.com"
            self.cargoType = "Cakes"
            self.tempMax = 2
            self.tempMin = -2
            self.deadline = Date(timeInterval: 12312231, since: Date())
            self.cargoValue = 100000
            self.depositor = .BUYER
            self.depositRate = 33
            self.owner = .SELLER
            self.status = .EXECUTED
            self.deposit = 33000
        }

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
        self.status = .NONE
    }
    
    static let shared = Contract(type: "shared")
    static let running = Contract(type: "running")
    static let executed = Contract(type: "executed")
    

}

enum Status: String {
    case AGREED
    case DECLINED
    case OFFERED
    case NONE
    case RUNNING
    case EXECUTED
}

enum CustomerType: String {
    case SELLER
    case BUYER
    case NONE
}
