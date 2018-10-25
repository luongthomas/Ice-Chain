//
//  String.swift
//  Ice-Chain
//
//  Created by Thomas Luong on 10/25/18.
//  Copyright © 2018 Thomas Luong. All rights reserved.
//

import Foundation

extension String {
    var digits: String {
        return trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
    }
}
