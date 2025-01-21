//
//  ProfileView.swift
//  MedPez
//
//  Created by Brian Lee on 1/14/25.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var name = ""
    @State private var email = ""

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
        }
        .padding()
        .onAppear(perform: fetchProfileData)
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
}


#Preview {
    ProfileView()
}
