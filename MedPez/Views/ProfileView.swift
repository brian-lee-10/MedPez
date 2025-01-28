import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var isLoggedOut = false
    @State private var showLogoutAlert = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Profile")
                .font(.largeTitle)
                .padding()

            VStack(alignment: .leading, spacing: 8) {
                Text("Name: \(name)")
                Text("Email: \(email)")
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)

            Spacer()

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
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
        .padding()
        .onAppear(perform: fetchProfileData)
        .fullScreenCover(isPresented: $isLoggedOut) {
            LoginView() // Redirect to LoginView upon logout
        }
    }

    private func fetchProfileData() {
        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching profile data: \(error.localizedDescription)")
                return
            }

            if let data = snapshot?.data() {
                self.name = data["name"] as? String ?? "N/A"
                self.email = data["email"] as? String ?? "N/A"
            }
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
