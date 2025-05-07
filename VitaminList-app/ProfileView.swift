//
//  ProfileView.swift
//  VitaminList-app
//
//  Created by Natalie S on 2025-05-06.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    

    @State private var meals: [Meal] = []
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var profileImageData: Data? = nil
    @State private var email = ""
    @State private var newPassword = ""
    @State private var showHistory = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    private var user: User? {
        Auth.auth().currentUser
    }

    var body: some View {
        NavigationStack {
            VStack {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Text("Add profile picture")
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                profileImageData = data
                                uploadProfileImage(data: data)
                            }
                        }
                    }

                if let user = user {
                    VStack {
                        Text("E-post: \(user.email ?? "Not given")")
                        TextField("Ny e-post", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        SecureField("Password", text: $newPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button("Update") {
                            updateUserProfile()
                        }
                        .padding()

                        Button("Logout") {
                            authViewModel.logout()
                        }
                        .padding()

                        
                        NavigationLink(destination: AddMealView(meals: $meals)) {
                            Text("Add a meal")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)

                        NavigationLink(destination: HistoryView(), isActive: $showHistory) {
                            Button("Visa historik") {
                                showHistory = true
                            }
                            .padding()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Profile")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Fel"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func uploadProfileImage(data: Data) {
        guard let user = user else { return }
        let storageRef = Storage.storage().reference().child("profile_images/\(user.uid).jpg")
        storageRef.putData(data, metadata: nil) { _, error in
            if let error = error {
                alertMessage = "Fel vid uppladdning: \(error.localizedDescription)"
                showAlert = true
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        alertMessage = "Fel vid hämtning av URL: \(error.localizedDescription)"
                        showAlert = true
                    } else if let url = url {
                        updateFirestoreProfileImageURL(url)
                    }
                }
            }
        }
    }

    private func updateFirestoreProfileImageURL(_ url: URL) {
        guard let user = user else { return }
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData(["profileImageURL": url.absoluteString], merge: true) { error in
            if let error = error {
                alertMessage = "Fel vid uppdatering av profilbild: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

    private func updateUserProfile() {
        guard let user = user else { return }

        if !email.isEmpty {
            user.updateEmail(to: email) { error in
                if let error = error {
                    alertMessage = "Fel vid uppdatering av e-post: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }

        if !newPassword.isEmpty {
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    alertMessage = "Fel vid uppdatering av lösenord: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}
