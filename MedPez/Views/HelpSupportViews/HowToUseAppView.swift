//
//  HowToUseAppView.swift
//  MedPez
//
//  Created by Brian Lee on 4/15/25.
//

import SwiftUI

struct HowToUseAppView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("How to Use MedPez")
                    .font(.custom("OpenSans-Bold", size: 24))

                Text("1. Add medications through the + button on the Calendar page.")
                Text("2. Set a time and dosage for each medication.")
                Text("3. View your scheduled tasks in the Calendar view.")
                Text("4. Track completion by tapping the circle next to each task.")
                Text("5. Edit your profile and settings from the Profile tab.")

                Spacer()
            }
            .padding()
        }
        .navigationTitle("How to Use App")
        .navigationBarTitleDisplayMode(.inline)
    }
}
