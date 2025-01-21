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
            ContentView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }

            LogView()
                .tabItem {
                    Image(systemName: "pills.fill")
                    Text("Medications")
                }
        }
    }
}

#Preview {
    MainTabView()
}
