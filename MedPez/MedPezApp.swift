//
//  MedPezApp.swift
//  MedPez
//
//  Created by Brian Lee on 11/19/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct MedPezApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isUserLoggedIn = false

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if isUserLoggedIn {
                    MainTabView()
                        .preferredColorScheme(.light)
                } else {
                    LoginView()
                        .background(.BG)
                        .preferredColorScheme(.light)
                }
            }
            .onAppear {
                checkAuthState()
            }
        }
    }

    private func checkAuthState() {
        // Check if a user is already signed in
        if Auth.auth().currentUser != nil {
            isUserLoggedIn = true
        } else {
            isUserLoggedIn = false
        }
    }
}
