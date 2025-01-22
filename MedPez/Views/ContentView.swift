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
                
                Text(getCurrentDayAndDate())
                                .font(.headline)
                                .padding(.top, 16)
                                .padding(.bottom, 8)
                            
                
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
    
    private func getCurrentDayAndDate() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM d, yyyy" // Example: "Monday, January 14, 2025"
            return dateFormatter.string(from: Date())
        }
}

//#Preview {
//    ContentView()
//}
