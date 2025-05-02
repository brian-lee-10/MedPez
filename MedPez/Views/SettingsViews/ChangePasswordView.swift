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
    @State private var showConfirmationAlert = false
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .hSpacing(.leading)
            .padding()
            
            Text("Change Password")
                .font(.custom("OpenSans-Bold", size: 28))
                .padding(.top, 5)
            
            /// Password Requirements List
            VStack(alignment: .leading, spacing: 5) {
                Text("Password must contain:")
                    .font(.custom("OpenSans-Bold", size: 14))
                
                HStack {
                    VStack{
                        Label("At least 1 uppercase letter", systemImage: hasUppercase ? "checkmark.circle.fill" : "xmark.circle")
                            .foregroundColor(hasUppercase ? .green : .red)
                        
                        Label("At least 1 lowercase letter", systemImage: hasLowercase ? "checkmark.circle.fill" : "xmark.circle")
                            .foregroundColor(hasLowercase ? .green : .red)
                    }
                    .font(.custom("OpenSans-Regular", size: 12))
                    
                    VStack {
                        Label("At least 1 number", systemImage: hasNumber ? "checkmark.circle.fill" : "xmark.circle")
                            .foregroundColor(hasNumber ? .green : .red)
                        
                        Label("Minimum 10 characters", systemImage: isLongEnough ? "checkmark.circle.fill" : "xmark.circle")
                            .foregroundColor(isLongEnough ? .green : .red)
                    }
                    .font(.custom("OpenSans-Regular", size: 12))
                }
            }
            .padding(.horizontal)
            
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

            Button(action: {
                showConfirmationAlert = true
            }) {
                Text("Update Password")
                    .font(.custom("OpenSans-Bold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color("SlateBlue"))
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
        .alert("Confirm Update", isPresented: $showConfirmationAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Update", role: .destructive) {
                changePassword()
            }
        } message: {
            Text("Are you sure you want to change your password?")
        }
    }
    
    private func changePassword() {
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            errorMessage = "User not found or not signed in."
            return
        }

        guard !oldPassword.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        guard newPassword == confirmPassword else {
            errorMessage = "New passwords do not match."
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)

        // Re-authenticate the user
        user.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                errorMessage = "Current password is incorrect. \(error.localizedDescription)"
            } else {
                // Update to the new password
                user.updatePassword(to: newPassword) { error in
                    if let error = error {
                        errorMessage = "Failed to update password. \(error.localizedDescription)"
                    } else {
                        // Success
                        DispatchQueue.main.async {
                            errorMessage = nil
                            oldPassword = ""
                            newPassword = ""
                            confirmPassword = ""
                            showSuccessAlert = true
                        }
                    }
                }
            }
        }
    }
    
    
    /// Live Password Check Functions
    var hasUppercase: Bool {
        newPassword.range(of: "[A-Z]", options: .regularExpression) != nil
    }

    var hasLowercase: Bool {
        newPassword.range(of: "[a-z]", options: .regularExpression) != nil
    }

    var hasNumber: Bool {
        newPassword.range(of: "[0-9]", options: .regularExpression) != nil
    }

    var isLongEnough: Bool {
        newPassword.count >= 10
    }


}

#Preview {
    ChangePasswordView()
}
