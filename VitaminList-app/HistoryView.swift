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
    
    var db = Firestore.firestore()

    var body: some View {
        VStack {
            Text("Måltidshistorik")
                .font(.title)
                .padding()

            
            if meals.isEmpty {
                Text("Inga måltider tillgängliga.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(meals) { meal in
                    VStack(alignment: .leading) {
                        Text("Protein: \(meal.protein)")
                        Text("Kolhydrater: \(meal.carbohydrates)")
                        Text("Sallad: \(meal.salad)")
                        Text("Sötsaker: \(meal.sweets)")
                        Text("Datum: \(meal.dateAdded, style: .date)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .padding()
        .navigationTitle("Historik")
        .onAppear {
            fetchMealsFromFirestore()
        }
    }


    private func fetchMealsFromFirestore() {
        db.collection("meals")
            .order(by: "dateAdded", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching meals: \(error)")
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
                        let dateAddedTimestamp = data["dateAdded"] as? Timestamp
                    else {
                        print("Invalid data for meal: \(document.documentID)")
                        return nil
                    }
                    
                    let dateAdded = dateAddedTimestamp.dateValue()
                    
                    return Meal(
                        id: document.documentID,
                        protein: protein,
                        carbohydrates: carbohydrates,
                        salad: salad,
                        sweets: sweets,
                        dateAdded: dateAdded
                    )
                }
            }
    }
}
