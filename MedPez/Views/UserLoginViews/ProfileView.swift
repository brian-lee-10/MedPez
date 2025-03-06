import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var birthdate = Date()
    @State private var isLoggedOut = false
    @State private var showLogoutAlert = false
    @State private var showSaveAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Profile")
                .font(.custom("OpenSans-Bold", size: 34))
                .padding()

            VStack(alignment: .leading, spacing: 8) {
                TextField("Name", text: $name)
                    .font(.custom("OpenSans-Regular", size: 17))
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                TextField("Email", text: $email)
                    .font(.custom("OpenSans-Regular", size: 17))
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .disabled(true) // Disable editing email

                DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)
                    .font(.custom("OpenSans-Regular", size: 17))
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)

            Spacer()


            Button(action: {
                saveProfile()
            }) {
                Text("Save")
                    .font(.custom("OpenSans-Regular", size: 17))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .alert(isPresented: $showSaveAlert) {
                Alert(title: Text("Profile"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }

            Button(action: {
                showLogoutAlert = true
            }) {
                Text("Log Out")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .alert("Log Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Log Out", role: .destructive) {
                    logoutUser()
                }
            }
        }
        .padding()
        .onAppear {
            loadProfile()
        }
        .fullScreenCover(isPresented: $isLoggedOut) {
            LoginView() // Redirect to LoginView upon logout
        }
    }

    private func loadProfile() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user.uid)

        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.name = data?["name"] as? String ?? ""
                self.email = data?["email"] as? String ?? ""
                if let birthdateTimestamp = data?["birthdate"] as? Timestamp {
                    self.birthdate = birthdateTimestamp.dateValue()
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    private func saveProfile() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData([
            "name": name,
            "birthdate": Timestamp(date: birthdate)
        ]) { error in
            if let error = error {
                alertMessage = "Error saving profile: \(error.localizedDescription)"
            } else {
                alertMessage = "Profile updated successfully!"
            }
            showSaveAlert = true
        }
    }

    private func logoutUser() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError.localizedDescription)
        }
    }
}

#Preview {
    ProfileView()
}
