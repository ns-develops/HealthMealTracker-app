//
//  AuhViewModel.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-04-30.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""

    init() {
        self.isLoggedIn = Auth.auth().currentUser != nil

        // Lyssna på autentiseringsstatus
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = user != nil
            }
        }
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
            } else {
                print("Login successful")
                DispatchQueue.main.async {
                    self?.isLoggedIn = true
                }
            }
        }
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Sign Up failed: \(error.localizedDescription)")
            } else {
                print("Sign Up successful")
                self?.login() 
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
