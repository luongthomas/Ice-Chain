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
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("contracts")
    
    init(type: String) {
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
            self.name = "Banana Contract"
            self.buyerEmail = "buyer@gmail.com"
            self.cargoType = "Bananas"
            self.tempMax = 21
            self.tempMin = 2
            self.deadline = Date(timeInterval: 1213112, since: Date())
            self.cargoValue = 142
            self.depositor = .BUYER
            self.depositRate = 67
            self.owner = .SELLER
            self.status = .RUNNING
            self.deposit = 95.14
            
        } else if type == "executed" {
            self.name = "Cake Contract"
            self.buyerEmail = "buyer@gmail.com"
            self.cargoType = "Cakes"
            self.tempMax = 2
            self.tempMin = -2
            self.deadline = Date(timeInterval: 12312231, since: Date())
            self.cargoValue = 112
            self.depositor = .BUYER
            self.depositRate = 33
            self.owner = .SELLER
            self.status = .EXECUTED
            self.deposit = 36.96
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
    
    
    //MARK: NSCoding
    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(name, forKey: PropertyKey.name)
//        aCoder.encode(photo, forKey: PropertyKey.photo)
//        aCoder.encode(rating, forKey: PropertyKey.rating)
//    }
//    
//    required convenience init?(coder aDecoder: NSCoder) {
//        
//        // The name is required. If we cannot decode a name string, the initializer should fail.
//        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
//            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
//            return nil
//        }
//        
//        // Because photo is an optional property of Meal, just use conditional cast.
//        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
//        
//        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
//        
//        // Must call designated initializer.
//        self.init(name: name, photo: photo, rating: rating)
//        
//    }

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
