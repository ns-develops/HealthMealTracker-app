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
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isUploadingProfileImage = false

    private var user: User? {
        Auth.auth().currentUser
    }

    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    Text("Profil")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    Button("Logga ut") {
                        authViewModel.logout()
                    }
                    .padding(.top, 10)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)

              
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Text("Välj en profilbild")
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
                            .padding()

                     
                        TextField("Ny e-post", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        SecureField("Lösenord", text: $newPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button("Uppdatera") {
                            updateUserProfile()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(hex: "#003366"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top)

                       
                        NavigationLink(destination: WeeklyStatusView(meals: $meals)) {
                            Text("Weekly Status")
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(hex: "#003366"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)

                        NavigationLink(destination: AddMealView(meals: $meals)) {
                            Text("Lägg till måltid")
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(hex: "#003366"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)

                        NavigationLink(destination: HistoryView(meals: $meals)) {
                            Text("Visa historik")
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color(hex: "#003366"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                    .padding()
                }

              
                if isUploadingProfileImage {
                    ProgressView("Laddar upp bild...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
    
            }
        }
    }


    private func uploadProfileImage(data: Data) {
        guard let user = user else { return }
        
        isUploadingProfileImage = true
        let storageRef = Storage.storage().reference().child("profile_images/\(user.uid).jpg")
        
        storageRef.putData(data, metadata: nil) { _, error in
            isUploadingProfileImage = false
            
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
