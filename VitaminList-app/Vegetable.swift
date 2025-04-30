//
//  Item.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-04-29.
//

import Foundation

struct Vegetable: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var vitamins: [String: Double]  
}
