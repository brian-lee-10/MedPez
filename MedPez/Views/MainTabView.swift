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
                .background(.BG)
                .preferredColorScheme(.light)

            // Log Tab
            LogView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Log")
                }
                .background(.BG)
                .preferredColorScheme(.light)

            // Add Medication Tab
//            AddMedicationView()
//                .tabItem {
//                    Image(systemName: "plus.circle.fill")
//                    Text("Add Medication")
//                }

            // Settings Tab
            BluetoothView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .background(.BG)
                .preferredColorScheme(.light)

            // Profile Tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .background(.BG)
                .preferredColorScheme(.light)
        }
        .modelContainer(for: Task.self)
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
}
