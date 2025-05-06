//
//  RootView.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-05-06.
//

import SwiftUI

struct RootView: View {
    @StateObject var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                ContentView()
                    .environmentObject(authViewModel)
            } else {
                LoginView(authViewModel: authViewModel)
            }
        }
    }
}
