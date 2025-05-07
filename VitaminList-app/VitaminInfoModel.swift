//
//  VitaminInfoModel.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-05-08.
//

struct VitaminInfo {
    var vitaminA: Double
    var vitaminB1: Double
    var vitaminB2: Double
    var vitaminB3: Double
    var vitaminB5: Double
    var vitaminB6: Double
    var vitaminB7: Double
    var vitaminB9: Double
    var vitaminB12: Double
    var vitaminC: Double
    var vitaminD: Double
    var vitaminE: Double
    var vitaminK: Double

    static var zero: VitaminInfo {
        return VitaminInfo(
            vitaminA: 0, vitaminB1: 0, vitaminB2: 0, vitaminB3: 0,
            vitaminB5: 0, vitaminB6: 0, vitaminB7: 0, vitaminB9: 0,
            vitaminB12: 0, vitaminC: 0, vitaminD: 0, vitaminE: 0, vitaminK: 0
        )
    }

    mutating func add(from data: [String: Any]) {
        vitaminA += data["vitaminA"] as? Double ?? 0
        vitaminB1 += data["vitaminB1"] as? Double ?? 0
        vitaminB2 += data["vitaminB2"] as? Double ?? 0
        vitaminB3 += data["vitaminB3"] as? Double ?? 0
        vitaminB5 += data["vitaminB5"] as? Double ?? 0
        vitaminB6 += data["vitaminB6"] as? Double ?? 0
        vitaminB7 += data["vitaminB7"] as? Double ?? 0
        vitaminB9 += data["vitaminB9"] as? Double ?? 0
        vitaminB12 += data["vitaminB12"] as? Double ?? 0
        vitaminC += data["vitaminC"] as? Double ?? 0
        vitaminD += data["vitaminD"] as? Double ?? 0
        vitaminE += data["vitaminE"] as? Double ?? 0
        vitaminK += data["vitaminK"] as? Double ?? 0
    }

    func toDictionary() -> [String: Any] {
        return [
            "vitaminA": vitaminA, "vitaminB1": vitaminB1, "vitaminB2": vitaminB2,
            "vitaminB3": vitaminB3, "vitaminB5": vitaminB5, "vitaminB6": vitaminB6,
            "vitaminB7": vitaminB7, "vitaminB9": vitaminB9, "vitaminB12": vitaminB12,
            "vitaminC": vitaminC, "vitaminD": vitaminD, "vitaminE": vitaminE, "vitaminK": vitaminK
        ]
    }
}
