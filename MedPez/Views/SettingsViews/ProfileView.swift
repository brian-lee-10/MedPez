import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var name = "NAME"
    @State private var email = "EMAIL"
    @State private var isLoggedOut = false
    @State private var showLogoutAlert = false

    var body: some View {
        VStack {
            // Profile Header
            VStack {
                Text("Profile")
                    .font(.custom("OpenSans-Bold", size:28))
                    .padding(.top, 10)
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding(.top, 10)
                
                Text(name)
                    .font(.custom("OpenSans-Bold", size:20))
                    .padding(.top, 5)
                
                Text(email)
                    .foregroundColor(.gray)
                    .font(.custom("OpenSans-Regular", size:16))
                    .padding(.bottom, 10)
                
                NavigationLink(destination: EditProfileView()) {
                    Text("Edit Profile")
                        .font(.custom("OpenSans-Bold", size: 20))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 40)

            }
            .background(Color.white)
            .padding(.bottom, 20)
            
            // Options List
            List {
                Section {
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gear")
                            .font(.custom("OpenSans-Regular", size:18))
                    }

//                    NavigationLink(destination: ContentView()) {
//                        Label("Change Password", systemImage: "lock")
//                            .font(.custom("OpenSans-Regular", size:18))
//                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            Spacer()
        }
        .onAppear {
            loadProfile()
        }
        .alert("Log Out", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Log Out", role: .destructive) {
                logoutUser()
            }
        }
        .fullScreenCover(isPresented: $isLoggedOut) {
            LoginView()
        }
    }
    
    private func loadProfile() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user.uid)

        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                DispatchQueue.main.async {
                    self.name = data?["name"] as? String ?? "Unknown"
                    self.email = data?["email"] as? String ?? "Unknown"
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    private func logoutUser() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
