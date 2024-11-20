import SwiftUI
import FirebaseAuth

struct BluetoothView: View {
//    @Environment(\.dismiss) var dismiss
    @State private var isLoggedOut = false // Track logout state

    var body: some View {
        VStack {
            Text("Bluetooth View")
                .font(.largeTitle)
                .padding()

            Text("Manage your Bluetooth connections here.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            Button(action: {
                logoutUser()
            }) {
                Text("Log Out")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
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
