//
//  LoginView.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-04-30.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    @State private var isSigningUp = false

    var body: some View {
        VStack(spacing: 20) {
            Text(isSigningUp ? "Sign Up" : "Log in")
                .font(.largeTitle)
                .bold()

            
            TextField("Email", text: $authViewModel.email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

       
            SecureField("Password", text: $authViewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

         
            Button(action: {
                isSigningUp ? authViewModel.signUp() : authViewModel.login()
            }) {
                Text(isSigningUp ? "Sign Up" : "Log In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.top)
            }

           
            Button(action: {
                isSigningUp.toggle()
            }) {
                Text(isSigningUp ? "Already have an account? Log In" : "Don't have an account? Sign Up")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
    }
}
