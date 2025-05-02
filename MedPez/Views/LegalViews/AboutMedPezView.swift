//
//  AboutMedPezView.swift
//  MedPez
//
//  Created by Brian Lee on 5/2/25.
//

import SwiftUI

struct AboutMedPezView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("About MedPez")
                    .font(.custom("OpenSans-Bold", size: 28))

                Text("MedPez is a smart medication tracking app that helps users stay on top of their daily prescriptions. Designed for personal use, it connects with the MedPez smart pill dispenser and provides real-time reminders, dose tracking, and progress monitoring.")
                    .font(.custom("OpenSans-Regular", size: 16))

                Text("Features:")
                    .font(.custom("OpenSans-Bold", size: 20))

                VStack(alignment: .leading, spacing: 10) {
                    Label("Smart pill dispenser pairing via Bluetooth", systemImage: "bolt.horizontal.circle")
                    Label("Daily medication reminders and scheduling", systemImage: "bell")
                    Label("Progress tracking and dose completion", systemImage: "checkmark.circle")
                    Label("Secure profile and data storage with Firebase", systemImage: "lock.shield")
                }
                .font(.custom("OpenSans-Regular", size: 16))

                Divider()

                VStack(alignment: .leading, spacing: 6) {
                    Text("App Version")
                        .font(.custom("OpenSans-Bold", size: 16))
                    Text("MedPez v1.0.0")
                        .font(.custom("OpenSans-Regular", size: 16))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Contact Support")
                        .font(.custom("OpenSans-Bold", size: 16))
                    Text("medpez.study@gmail.com")
                        .font(.custom("OpenSans-Regular", size: 16))
                        .foregroundColor(.blue)
                }

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    AboutMedPezView()
}
