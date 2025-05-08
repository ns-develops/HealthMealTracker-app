//
//  HistoryView.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-05-06.
//
import SwiftUI
import FirebaseFirestore

struct HistoryView: View {
    @Binding var meals: [Meal]
    @State private var checkedMeals: [String: Bool] = [:]
    var db = Firestore.firestore()

    var body: some View {
        VStack {
            Text("Meal History")
                .font(.title)
                .padding()
            
            if meals.isEmpty {
                Text("No meals available.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(meals) { meal in
                    HStack {
                        Toggle(isOn: Binding(
                            get: { checkedMeals[meal.id ?? ""] ?? meal.done },
                            set: { newValue in
                                checkedMeals[meal.id ?? ""] = newValue
                                
                                if newValue {
                                  
                                    updateMealStatus(meal.id ?? "", done: true)
                                } else {
                                    
                                    removeMeal(meal.id ?? "")
                                }
                            }
                        )) {
                            VStack(alignment: .leading) {
                                Text("Protein: \(meal.protein)")
                                Text("Carbs: \(meal.carbohydrates)")
                                Text("Salad: \(meal.salad)")
                                Text("Sweets: \(meal.sweets)")
                                    .foregroundColor(.secondary)
                                Text("Date: \(meal.dateAdded, style: .date)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            fetchMealsFromFirestore()
        }
    }


    private func updateMealStatus(_ mealId: String, done: Bool) {
        let mealRef = db.collection("meals").document(mealId)
        
        mealRef.updateData([
            "done": done
        ]) { error in
            if let error = error {
                print("Error updating meal status: \(error.localizedDescription)")
            } else {
                print("Meal status updated successfully.")
            }
        }
    }


    private func removeMeal(_ mealId: String) {
        // Ta bort måltiden från Firestore
        db.collection("meals").document(mealId).delete { error in
            if let error = error {
                print("Error deleting meal: \(error.localizedDescription)")
            } else {
             
                if let index = meals.firstIndex(where: { $0.id == mealId }) {
                    meals.remove(at: index)
                }
                print("Meal deleted successfully.")
            }
        }
    }


    private func fetchMealsFromFirestore() {
        db.collection("meals")
            .order(by: "dateAdded", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching meals: \(error.localizedDescription)")
                    return
                }

                guard let snapshot = snapshot else {
                    print("Snapshot is nil")
                    return
                }
                
                meals = snapshot.documents.compactMap { document -> Meal? in
                    let data = document.data()
                    
                    guard
                        let protein = data["protein"] as? String,
                        let carbohydrates = data["carbohydrates"] as? String,
                        let salad = data["salad"] as? String,
                        let sweets = data["sweets"] as? String,
                        let dateAddedTimestamp = data["dateAdded"] as? Timestamp,
                        let done = data["done"] as? Bool
                    else {
                        print("Invalid data for document: \(document.documentID)")
                        return nil
                    }
                    
                    let dateAdded = dateAddedTimestamp.dateValue()
                    
                    return Meal(
                        id: document.documentID,
                        protein: protein,
                        carbohydrates: carbohydrates,
                        salad: salad,
                        sweets: sweets,
                        dateAdded: dateAdded,
                        done: done
                    )
                }
            }
    }
}
