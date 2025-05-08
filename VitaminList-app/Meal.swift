//
//  MealModel.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-05-07.
//

import Foundation
import FirebaseFirestore



struct Meal: Identifiable {
    var id: String?
    var protein: String
    var carbohydrates: String
    var salad: String
    var sweets: String
    var dateAdded: Date
    var done: Bool
}

extension Meal {
  
    init?(document: [String: Any]) {
        guard
            let protein = document["protein"] as? String,
            let carbohydrates = document["carbohydrates"] as? String,
            let salad = document["salad"] as? String,
            let sweets = document["sweets"] as? String,
            let timestamp = document["dateAdded"] as? Timestamp,
            let done = document["done"] as? Bool
        else {
            return nil
        }

    
        self.id = document["id"] as? String
        self.protein = protein
        self.carbohydrates = carbohydrates
        self.salad = salad
        self.sweets = sweets
        self.dateAdded = timestamp.dateValue()
        self.done = done
    }
}
