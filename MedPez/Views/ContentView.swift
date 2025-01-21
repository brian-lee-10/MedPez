//
//  ContentView.swift
//  MedPez
//
//  Created by Brian Lee on 11/19/24.

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    // Profile NavigationLink
                    NavigationLink(destination: ProfileView()) {
                        Image("Profile")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    
                    Spacer()
                    
                    // Bluetooth and Unlock NavigationLinks
                    HStack(spacing: 20) {
                        NavigationLink(destination: BluetoothView()) {
                            Image("Bluetooth")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                        NavigationLink(destination: LogView()) { // Change if needed
                            Image("Unlock")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                VStack {
                    Text("MedPez")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
