//
//  AddMealView.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-05-07.
//

import SwiftUI
import FirebaseFirestore

struct AddMealView: View {
    @Binding var meals: [Meal]
    
    @State private var protein = ""
    @State private var carbohydrates = ""
    @State private var salad = ""
    @State private var sweets = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Add a meal")
                .font(.title)

            TextField("Protein", text: $protein)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Carbohydrates", text: $carbohydrates)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Greens", text: $salad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Sweets", text: $sweets)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Save meal") {
                // Save the meal to Firestore
                saveMealToFirestore()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top)
        }
        .padding()
        .navigationTitle("Add Meal")
    }
    
 
    private func saveMealToFirestore() {
        let newMeal = Meal(
            id: nil, 
            protein: protein,
            carbohydrates: carbohydrates,
            salad: salad,
            sweets: sweets,
            dateAdded: Date()
        )
        
        let db = Firestore.firestore()
        
        db.collection("meals").addDocument(data: [
            "protein": newMeal.protein,
            "carbohydrates": newMeal.carbohydrates,
            "salad": newMeal.salad,
            "sweets": newMeal.sweets,
            "dateAdded": newMeal.dateAdded
        ]) { error in
            if let error = error {
                print("Error saving meal: \(error.localizedDescription)")
            } else {
                print("Meal saved successfully.")
            }
        }
    }
}
