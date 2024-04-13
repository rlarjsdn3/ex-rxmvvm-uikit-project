//
//  Repository.swift
//  ExRxMVVM
//
//  Created by 김건우 on 4/13/24.
//

import Foundation

struct Repository: Decodable {
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items = "items"
    }
    var totalCount: Int
    var items: [Item]
}

struct Item: Decodable {
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
    }
    var fullName: String
}
