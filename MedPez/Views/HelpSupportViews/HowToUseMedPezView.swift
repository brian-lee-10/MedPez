//
//  HowToUseMedPezView.swift
//  MedPez
//
//  Created by Brian Lee on 4/21/25.
//

import SwiftUI

struct HowToUseMedPezView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("How to Use MedPez Device")
                    .font(.custom("OpenSans-Bold", size: 24))

                Spacer()
            }
            .padding()
        }
        .navigationTitle("How to Use MedPez")
        .navigationBarTitleDisplayMode(.inline)
    }
}
