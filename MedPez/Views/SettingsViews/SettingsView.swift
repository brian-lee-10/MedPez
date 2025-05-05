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
    @State private var showDeleteAlert = false
    @State private var isDeletingAccount = false
    @State private var showChangePassword = false

    var body: some View {
        VStack {
            Text("Settings")
                .font(.custom("OpenSans-Bold", size: 28))
                .padding(.top, 20)

            List {
                Section(header: Text("Account Security")){
                    Button {
                            showChangePassword = true
                    } label: {
                        Label("Change Password", systemImage: "key.fill")
                            .font(.custom("OpenSans-Regular", size: 18))
                            .foregroundStyle(.black)
                    }
                }
                
                Section(header: Text("Support & Device")){
                    NavigationLink(destination: BluetoothView()) {
                        Label("My Device", systemImage: "dot.radiowaves.left.and.right")
                            .font(.custom("OpenSans-Regular", size:18))
                    }
                    
                    NavigationLink(destination: HelpSupportView()) {
                        Label("Support Center", systemImage: "questionmark.circle")
                            .font(.custom("OpenSans-Regular", size:18))
                    }
                }
                
                Section(header: Text("Legal & App Info")) {
                    NavigationLink(destination: TermsOfServiceView()) {
                        Label("Terms of Service", systemImage: "doc.text")
                            .font(.custom("OpenSans-Regular", size: 18))
                    }

                    NavigationLink(destination: PrivacyPolicyView()) {
                        Label("Privacy Policy", systemImage: "lock.shield")
                            .font(.custom("OpenSans-Regular", size: 18))
                    }
                    
                    NavigationLink(destination: MedicalDisclaimerSettingsView()) {
                            Label("Medical Disclaimer", systemImage: "exclamationmark.shield")
                                .font(.custom("OpenSans-Regular", size: 18))
                        }
                    
                    NavigationLink(destination: AboutMedPezView()) {
                        Label("About MedPez", systemImage: "info.circle")
                            .font(.custom("OpenSans-Regular", size: 18))
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Label("Delete My Account", systemImage: "trash")
                                .foregroundColor(.red)
                                .font(.custom("OpenSans-Regular", size: 18))
                        }
                    }
                }
                .alert("Delete Account?", isPresented: $showDeleteAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Delete", role: .destructive) {
                        isDeletingAccount = true
                        DeleteAccountHelper.deleteUserAccount { result in
                            DispatchQueue.main.async {
                                isDeletingAccount = false
                                switch result {
                                case .success:
                                    isLoggedOut = true  // redirect to LoginView
                                case .failure(let error):
                                    print("Error deleting account: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                } message: {
                    Text("This action will permanently delete your account, including all medical data and profile information. This data cannot be recovered.")
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
        .sheet(isPresented: $showChangePassword) {
            ChangePasswordView()
                .presentationDetents([.height(550)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(.BG)
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
