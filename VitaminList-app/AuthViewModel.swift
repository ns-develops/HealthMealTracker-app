//
//  AuhViewModel.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-04-30.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var email = ""
    @Published var password = ""

    init() {
        self.isLoggedIn = Auth.auth().currentUser != nil
    }

    // Login funktion
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
            } else {
                print("Login successful")
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                }
            }
        }
    }

   
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Sign Up failed: \(error.localizedDescription)")
            } else {
                print("Sign Up successful")
                self.login()
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }
}
