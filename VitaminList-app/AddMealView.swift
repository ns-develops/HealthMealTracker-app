//
//  AddMealView.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-05-07.
//

import SwiftUI

struct AddMealView: View {
    @Environment(\.dismiss) var dismiss
    @State private var protein = ""
    @State private var carbohydrates = ""
    @State private var salad = ""
    @State private var sweets = ""
    
    @Binding var meals: [Meal]

    var body: some View {
        VStack {
            Text("Add a meal")
                .font(.largeTitle)
                .padding()

            TextField("Protein", text: $protein)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Carbohydrate", text: $carbohydrates)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Greens", text: $salad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Sweets", text: $sweets)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save meal") {
                let newMeal = Meal(protein: protein, carbohydrates: carbohydrates, salad: salad, sweets: sweets)
                meals.append(newMeal)
                dismiss()  
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

