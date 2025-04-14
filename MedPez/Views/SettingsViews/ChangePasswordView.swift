//
//  ChangePasswordView.swift
//  MedPez
//
//  Created by Brian Lee on 4/14/25.
//

import SwiftUI
import FirebaseAuth

struct ChangePasswordView: View {
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @State private var showSuccessAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Change Password")
                .font(.custom("OpenSans-Bold", size: 28))
                .padding(.top, 20)

            SecureField("Current Password", text: $oldPassword)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .padding(.horizontal)

            SecureField("New Password", text: $newPassword)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .padding(.horizontal)

            SecureField("Confirm New Password", text: $confirmPassword)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .padding(.horizontal)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            Button(action: changePassword) {
                Text("Update Password")
                    .font(.custom("OpenSans-Bold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.horizontal)

            Spacer()
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Password updated successfully.")
        }
    }

    private func changePassword() {
        guard !oldPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard newPassword == confirmPassword else {
            errorMessage = "New passwords do not match."
            return
        }

        guard let user = Auth.auth().currentUser, let email = user.email else {
            errorMessage = "User not found."
            return
        }

        // Re-authenticate
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        user.reauthenticate(with: credential) { result, error in
            if let error = error {
                errorMessage = "Incorrect current password."
            } else {
                user.updatePassword(to: newPassword) { error in
                    if let error = error {
                        errorMessage = "Error updating password: \(error.localizedDescription)"
                    } else {
                        showSuccessAlert = true
                        errorMessage = nil
                        oldPassword = ""
                        newPassword = ""
                        confirmPassword = ""
                    }
                }
            }
        }
    }
}

#Preview {
    ChangePasswordView()
}
