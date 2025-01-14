import SwiftUI
import FirebaseAuth

struct BluetoothView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isLoggedOut = false // Track logout state
    @State private var showLogoutAlert = false // Show confirmation alert
    @State private var userEmail: String = "" // Store the user's email

    var body: some View {
        VStack {
            Text("Bluetooth View")
                .font(.largeTitle)
                .padding()

            if !userEmail.isEmpty {
                Text("Logged in as: \(userEmail)")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
            }

            Text("Manage your Bluetooth connections here.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()

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
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image("Back") // Replace with your asset's name
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                }
//            }
//        }
        .fullScreenCover(isPresented: $isLoggedOut) {
            LoginView() // Redirect to LoginView upon logout
        }
        .onAppear {
            fetchUserEmail()
        }
    }

    private func fetchUserEmail() {
        if let user = Auth.auth().currentUser {
            userEmail = user.email ?? "Unknown User"
        } else {
            userEmail = "Not logged in"
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
    BluetoothView()
}
