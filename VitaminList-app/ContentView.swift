//
//  ContentView.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-04-29.
//
//

import SwiftUI

struct ContentView: View {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var uploader = VegetableUploader()
    
    @State private var meals: [Meal] = []
    
    @State private var protein = ""
    @State private var carbohydrates = ""
    @State private var salad = ""
    @State private var sweets = ""

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                VStack(spacing: 20) {
                    HStack {
                        Text("Vegetable List")
                            .font(.title)
                        Spacer()
                        Button("Log out") {
                            authViewModel.logout()
                        }
                        .foregroundColor(.red)
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    VStack {
                        Text("Add a meal")
                            .font(.headline)
                        TextField("Protein", text: $protein)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        TextField("Kolhydrater", text: $carbohydrates)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        TextField("Sallad", text: $salad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        TextField("Sötsaker", text: $sweets)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button("Save meal") {
                           
                            let newMeal = Meal(
                                id: nil,
                                protein: protein,
                                carbohydrates: carbohydrates,
                                salad: salad,
                                sweets: sweets,
                                dateAdded: Date(),
                                done: false
                            )
                            
                            meals.append(newMeal)
                            
                            protein = ""
                            carbohydrates = ""
                            salad = ""
                            sweets = ""
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top)

                        List(meals) { meal in
                            VStack(alignment: .leading) {
                                Text("Protein: \(meal.protein)")
                                Text("Kolhydrater: \(meal.carbohydrates)")
                                Text("Sallad: \(meal.salad)")
                                Text("Sötsaker: \(meal.sweets)")
                                    .foregroundColor(.secondary)
                                Text("Datum: \(meal.dateAdded, style: .date)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                    }

                    Button(action: {
                        uploader.uploadVegetables()
                    }) {
                        Text("Upload Vegetables")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

                    List(uploader.vegetables) { vegetable in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(vegetable.name)
                                .font(.headline)
                            Text("Vitamins: \(vegetable.vitamins.map { "\($0.key): \($0.value)" }.joined(separator: ", "))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onAppear {
                    uploader.fetchVegetables()
                }
            } else {
                LoginView(authViewModel: authViewModel)
            }
        }
    }
}
