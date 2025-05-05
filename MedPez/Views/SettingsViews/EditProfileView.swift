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
    @State private var showSuccessAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Profile")
                .font(.custom("OpenSans-Bold", size: 28))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            // Profile Form
            VStack(spacing: 20) {
                ProfileField(title: "Full Name") {
                    TextField("Enter your name", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                }

                ProfileField(title: "Email") {
                    Text(email)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }

                ProfileField(title: "Birthdate (optional)") {
                    DatePicker("Select a birthdate", selection: Binding(
                        get: { birthdate ?? Date() },
                        set: { birthdate = $0 }
                    ), displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
                }
            }
            .padding()
            .background(Color("Smoke"))
            .cornerRadius(20)
            .padding(.horizontal)

            Button(action: updateProfile) {
                Text("Save Changes")
                    .font(.custom("OpenSans-Bold", size: 20))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("SlateBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .onAppear(perform: loadProfile)
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
