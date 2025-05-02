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
        ScrollView {
            VStack(spacing: 25) {
                Text("Edit Profile")
                    .font(.custom("OpenSans-Bold", size: 28))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                Group {
                    ProfileField(title: "Full Name") {
                        TextField("Enter your name", text: $name)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                    }

                    ProfileField(title: "Email") {
                        Text(email)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }

                    ProfileField(title: "Birthdate (optional)") {
                        DatePicker("Select a birthdate", selection: Binding(get: {
                            birthdate ?? Date()
                        }, set: { newDate in
                            birthdate = newDate
                        }), displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                    }
                }
                .padding(.horizontal)

                VStack(spacing: 15) {
                    Button(action: updateProfile) {
                        Text("Save Changes")
                            .font(.custom("OpenSans-Bold", size: 20))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color("SlateBlue"))
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }

                    Button(action: {
                        showPasswordReset = true
                    }) {
                        Text("Change Password")
                            .font(.custom("OpenSans-Bold", size: 20))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color("SlateBlue"))
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .onAppear(perform: loadProfile)
        .sheet(isPresented: $showPasswordReset) {
            ChangePasswordView()
                .presentationDetents([.height(550)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(.BG)
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

        Firestore.firestore().collection("users").document(user.uid).getDocument { document, error in
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

        Firestore.firestore().collection("users").document(user.uid).updateData(updateData) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                showSuccessAlert = true
            }
        }
    }
}

/// Reusable section with title and field
@ViewBuilder
func ProfileField<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: 8) {
        Text(title)
            .font(.custom("OpenSans-Bold", size: 16))
        content()
    }
}


#Preview {
    EditProfileView()
}
