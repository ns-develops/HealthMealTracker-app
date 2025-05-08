//
//  MealViewModel.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-05-08.
//

import Foundation
import FirebaseFirestore

class MealViewModel: ObservableObject {
    @Published var weeklyStatus: [String: Int] = [:]
    

    func fetchWeeklyStatus() {
        let db = Firestore.firestore()
        
        
        db.collection("meals")
            .whereField("dateAdded", isGreaterThanOrEqualTo: Date().addingTimeInterval(-7 * 24 * 60 * 60))
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Fel vid hämtning av måltider: \(error.localizedDescription)")
                    return
                }
                
                self.weeklyStatus = [:]
                
               
                snapshot?.documents.forEach { document in
                    if let meal = Meal(document: document.data()) {
                        let day = self.getDayString(from: meal.dateAdded)
                        
                        // Räkna antalet dagar per typ (t.ex. protein)
                        if self.weeklyStatus[meal.protein] == nil {
                            self.weeklyStatus[meal.protein] = 1
                        } else {
                            self.weeklyStatus[meal.protein]! += 1
                        }
                    }
                }
            }
    }
    
   
    private func getDayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
