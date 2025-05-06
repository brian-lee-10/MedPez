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
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // Called when a notification is delivered while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NotificationCenter.default.post(name: .medicationReminderFired, object: nil)

        // Optionally show the banner/sound while foreground
        completionHandler([.banner, .sound])
    }
}

@main
struct MedPezApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isUserLoggedIn = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @StateObject var bluetoothManager = BluetoothManager()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if !hasSeenOnboarding {
                    OnboardingView()
                        .preferredColorScheme(.light)
                }
                else if isUserLoggedIn {
                    ContentView()
                        .preferredColorScheme(.light)

                } else {
                    LoginView()
                        .background(.BG)
                        .preferredColorScheme(.light)
                }
            }
            .environmentObject(bluetoothManager)
            .modelContainer(for: Task.self)
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
