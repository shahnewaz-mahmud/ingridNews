//
//  User.swift
//  IngridNews
//
//  Created by BJIT on 1/17/23.
//

import Foundation

struct User: Encodable, Decodable {
    var theme: String
    var isDarkmode: Bool
    var lastSync: Date
}

