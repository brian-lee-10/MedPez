//
//  MedicalDisclaimerSettingsView.swift
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
                MepDez is a personal medication tracking tool intended solely for informational and reminder purposes. It does not provide medical advice, diagnosis, or treatment. This app is not intended to diagnose, treat, cure, or prevent any disease. Always consult a licensed healthcare provider before making medical decisions or changes to your medication regimen.
                
                All medication names and dosages are manually entered by the user. MedPez does not verify the accuracy or appropriateness of this information. Users should always refer to prescription labels or over-the-counter instructions when entering medication details.
                
                Bluetooth connectivity and notification performance may vary depending on your device and system settings. Users are solely responsible for verifying their own medication intake and adherence.
                
                By using MedPez, you acknowledge and agree that the app and its developers are not liable for any harm resulting from missed doses, incorrect medication use, or reliance on app-generated reminders.
                """)
            }
                .font(.custom("OpenSans-Regular", size: 16))
                .padding()


            Spacer()
        }
        .padding()
    }
}

#Preview {
    MedicalDisclaimerView { }
}
