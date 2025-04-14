//
//  EditProfileView.swift
//  MedPez
//
//  Created by Brian Lee on 4/13/25.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct EditProfileView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var birthdate: Date? = nil
    @State private var showPasswordReset = false
    @State private var showSuccessAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Profile")
                .font(.custom("OpenSans-Bold", size: 28))
                .padding(.top, 20)

            VStack(alignment: .leading, spacing: 10) {
                Text("Full Name")
                    .font(.custom("OpenSans-Bold", size: 16))

                TextField("Enter your name", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))

                Text("Email")
                    .font(.custom("OpenSans-Bold", size: 16))

                Text(email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                Text("Birthdate (optional)")
                    .font(.custom("OpenSans-Bold", size: 16))

                DatePicker("Select a birthdate", selection: Binding(get: {
                    birthdate ?? Date()
                }, set: { newDate in
                    birthdate = newDate
                }), displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            }
            .padding(.horizontal)

            Button(action: {
                updateProfile()
            }) {
                Text("Save Changes")
                    .font(.custom("OpenSans-Bold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.horizontal)

            Button(action: {
                showPasswordReset = true
            }) {
                Text("Change Password")
                    .font(.custom("OpenSans-Bold", size: 18))
                    .foregroundColor(.blue)
            }
            .padding(.top, 10)

            Spacer()
        }
        .onAppear(perform: loadProfile)
        .sheet(isPresented: $showPasswordReset) {
            ChangePasswordView()
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Profile updated successfully.")
        }
    }

    private func loadProfile() {
        guard let user = Auth.auth().currentUser else { return }
        email = user.email ?? ""

        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user.uid)

        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                name = data?["name"] as? String ?? ""

                if let timestamp = data?["birthdate"] as? Timestamp {
                    birthdate = timestamp.dateValue()
                } else {
                    birthdate = nil
                }
            }
        }
    }

    private func updateProfile() {
        guard let user = Auth.auth().currentUser else { return }

        var updateData: [String: Any] = ["name": name]
        if let birthdate = birthdate {
            updateData["birthdate"] = Timestamp(date: birthdate)
        }

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData(updateData) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                showSuccessAlert = true
            }
        }
    }
}

#Preview {
    EditProfileView()
}
