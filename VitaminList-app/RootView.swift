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
        NavigationView {
            Group {
                if authViewModel.isLoggedIn {
                    ProfileView() // <-- Visa profilvy efter inloggning
                        .environmentObject(authViewModel)
                } else {
                    LoginView(authViewModel: authViewModel)
                }
            }
        }
    }
}
