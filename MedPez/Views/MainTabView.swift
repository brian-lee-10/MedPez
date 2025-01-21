//
//  MainTabView.swift
//  MedPez
//
//  Created by Brian Lee on 1/20/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Home Tab
            ContentView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            // Log Tab
            LogView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Log")
                }

            // Add Medication Tab
            AddMedicationView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Medication")
                }

            // Settings Tab
            BluetoothView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }

            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(.blue) // Optional: Customize the active tab color
    }
}

#Preview {
    MainTabView()
}
