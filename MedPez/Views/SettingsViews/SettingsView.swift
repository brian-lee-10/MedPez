//
//  SettingsView.swift
//  MedPez
//
//  Created by Brian Lee on 4/13/25.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @State private var showLogoutAlert = false
    @State private var isLoggedOut = false

    var body: some View {
        VStack {
            Text("Settings")
                .font(.custom("OpenSans-Bold", size: 28))
                .padding(.top, 20)

            List {
                Section {
                    NavigationLink(destination: BluetoothView()) {
                        Label("My Device", systemImage: "dot.radiowaves.left.and.right")
                            .font(.custom("OpenSans-Regular", size:18))
                    }
                    
                    NavigationLink(destination: HelpSupportView()) {
                        Label("Support Center", systemImage: "questionmark.circle")
                            .font(.custom("OpenSans-Regular", size:18))
                    }
                }

                Section {
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        Label("Log Out", systemImage: "arrow.right.square")
                            .foregroundColor(.red)
                            .font(.custom("OpenSans-Regular", size:18))
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
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

    private func logoutUser() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SettingsView()
}
