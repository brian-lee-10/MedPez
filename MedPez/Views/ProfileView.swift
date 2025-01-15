//
//  ProfileView.swift
//  MedPez
//
//  Created by Brian Lee on 1/14/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var name = ""
    @State private var age = ""
    @State private var email = Auth.auth().currentUser?.email ?? ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    private let db = Firestore.firestore()

    var body: some View {
        VStack(spacing: 20) {
            Text("Profile Management")
                .font(.largeTitle)
                .padding()

            TextField("Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            TextField("Age", text: $age)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

//            Button(action: updateProfile) {
//                Text("Update Profile")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }

//            Button(action: updatePassword) {
//                Text("Update Password")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.green)
//                    .foregroundColor(.white)
//                    .cornerRadius(8)
//            }

            Spacer()
        }
        .padding()
        .onAppear(perform: loadProfile)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Profile Update"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func loadProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                self.name = document.get("name") as? String ?? ""
                self.age = "\(document.get("age") as? Int ?? 0)"
            } else {
                print("Error loading profile: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    private func updateProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let ageInt = Int(age), ageInt >= 0 else {
            alertMessage = "Please enter a valid age."
            showAlert = true
            return
        }

        db.collection("users").document(userId).setData([
            "name": name,
            "age": ageInt
        ], merge: true) { error in
            if let error = error {
                alertMessage = "Error updating profile: \(error.localizedDescription)"
            } else {
                alertMessage = "Profile updated successfully!"
            }
            showAlert = true
        }
    }

    private func updatePassword() {
        // Prompt the user to enter a new password (e.g., via an alert or new screen)
        let newPassword = "newPassword123" // Replace with user input
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                alertMessage = "Error updating password: \(error.localizedDescription)"
            } else {
                alertMessage = "Password updated successfully!"
            }
            showAlert = true
        }
    }
}

#Preview {
    ProfileView()
}
