//
//  Addresses.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/9/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation

struct AccountAddress: Decodable {
    var result: [[AccountAddressInfo]]
    var id : String
    var error : String?
}

struct AccountAddressInfo: Decodable {
    var address: String
    var amount: Double
    var accountType: String?

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        address = try container.decode(String.self)
        amount = try container.decode(Double.self)
        
        do {
            accountType = try container.decode(String.self)
        } catch {
            
        }
        
    }
}
