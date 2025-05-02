//
//  MedicalDisclaimerSettingsView.swift
//  MedPez
//
//  Created by Brian Lee on 5/1/25.
//

//
//  MedicalDisclaimerView.swift
//  MedPez
//
//  Created by Brian Lee on 5/1/25.
//

import SwiftUI

struct MedicalDisclaimerSettingsView: View {

    var body: some View {
        VStack(spacing: 20) {
            Text("Medical Disclaimer")
                .font(.custom("OpenSans-Bold", size: 26))
                .padding(.top)

            ScrollView {
                Text("""
MedPez is a medication tracking app intended for personal use only. It does not provide medical or pharmaceutical advice. Always consult a licensed healthcare provider for questions regarding medication, dosage, or timing.

Bluetooth connectivity and reminder functionality may be impacted by your device or system settings. Users are solely responsible for verifying their own medication intake and adherence.

By using this app, you acknowledge and accept that MedPez is not liable for any harm resulting from missed or incorrect medication intake.
""")
                .font(.custom("OpenSans-Regular", size: 16))
                .padding()
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    MedicalDisclaimerView { }
}
