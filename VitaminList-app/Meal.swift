//
//  MealModel.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-05-07.
//

import Foundation

struct Meal: Identifiable {
    var id = UUID()
    var protein: String
    var carbohydrates: String
    var salad: String
    var sweets: String
}
