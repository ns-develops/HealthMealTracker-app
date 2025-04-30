//
//  ContentView.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-04-29.
//

import SwiftUI

struct ContentView: View {
    @StateObject var uploader = VegetableUploader()

    var body: some View {
        VStack(spacing: 20) {
            Text("Vegetable List")
                .font(.title)
                .padding(.top)

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
    }
}
