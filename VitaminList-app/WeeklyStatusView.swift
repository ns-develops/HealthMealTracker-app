//
//  WeeklyStatusView.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-05-08.
//

import SwiftUI

struct WeeklyStatusView: View {
    @Binding var meals: [Meal]
    

    private var mealCount: [String: Int] {
  
        var countDict = [String: Int]()
        for meal in meals {
            let mealName = meal.name
            countDict[mealName, default: 0] += 1
        }
        return countDict
    }

    var body: some View {
        VStack {
            Text("Weekly Status")
                .font(.largeTitle)
                .padding()


            VStack {
                ForEach(mealCount.keys.sorted(), id: \.self) { mealName in
                    let count = mealCount[mealName] ?? 0
                    Text("\(mealName): \(count) gång(er)")
                        .font(.title2)
                        .padding(.top)

                    if mealName.lowercased().contains("salad") {
                        Text("Bra jobbat, c-vitamin är bra för immunförsvaret!")
                            .font(.subheadline)
                            .foregroundColor(.green)
                            .padding(.top, 5)
                    }
                }
            }

            Spacer()
        }
        .onAppear {
            
            fetchWeeklyData()
        }
    }

   
    private func fetchWeeklyData() {
       
    }
}
