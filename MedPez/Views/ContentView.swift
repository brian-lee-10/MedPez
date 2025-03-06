//
//  ContentView.swift
//  MedPez
//
//  Created by Brian Lee on 11/19/24.

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    
    var body: some View {
        VStack {
            HStack {
                Text(getCurrentDayAndDate())
                    .font(.custom("OpenSans-Regular", size:34))
                    .bold()
                Spacer()
            }
            .padding()
            Spacer()
//            NavigationLink (destination: TestView()){
//                Text("BLE Test View")
//                    .font(.custom("OpenSans-Regular", size: 20))
//            }
            // Spacer()
        }
    }
    
    private func getCurrentDayAndDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d" // Example: "Tuesday, Nov 19"
        return formatter.string(from: Date())
    }
}

#Preview {
    ContentView()
}
