//
//  CurrentUser.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/11/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation

struct Users {
    
    var buyerAddresses = [String]()
    var sellerAddresses = [String]()
    
    var buyerBalance = 0.0
    var sellerBalance = 0.0
    
    var currentUser = "Buyer"
    var currentBalance = 0.0
    var currentAddress = ""
    
    let sellerType = "seller"
    let buyerType = "buyer"
    
    
    private init() {
        
    }
    
    mutating func setSellerAsCurrentUser() {
        currentBalance = sellerBalance
        if let first = sellerAddresses.first {
            currentAddress = first
        }
        currentUser = "Seller"
    }
    
    mutating func setBuyerAsCurrentUser() {
        currentBalance = buyerBalance
        if let first = buyerAddresses.first {
            currentAddress = first
            
        }
        currentUser = "Buyer"
    }
    
    static var shared = Users()
}
