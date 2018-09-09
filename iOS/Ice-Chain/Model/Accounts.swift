//
//  Accounts.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 9/9/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation

struct Accounts: Codable {
    var result : Result
    var id : String
    var error : String?

}

struct Result: Codable {
    let buyer : Double
    let seller : Double
}
