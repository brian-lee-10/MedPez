//
//  TermsOfServiceView.swift
//  MedPez
//
//  Created by Brian Lee on 5/1/25.
//  Updated for App Store Compliance on 5/5/25
//

import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Terms of Service")
                    .font(.custom("OpenSans-Bold", size: 28))
                    .padding(.bottom, 5)

                Group {
                    Text("By accessing or using MedPez, you agree to be bound by these Terms of Service. If you do not agree, do not use the app.")

                    Text("1. Use of the App")
                        .bold()
                    Text("You must be 18 or older to use this app. MedPez is intended for personal, non-commercial use only. It is not a substitute for professional medical advice, diagnosis, or treatment.")

                    Text("2. Account Responsibility")
                        .bold()
                    Text("You are responsible for maintaining the confidentiality of your account credentials and any activity under your account.")

                    Text("3. No Medical Advice")
                        .bold()
                    Text("MedPez provides reminders and tracking for medication, but it does not offer medical or pharmaceutical advice. Always consult your healthcare provider for medical decisions.")

                    Text("4. License to Use")
                        .bold()
                    Text("MedPez grants you a limited, non-exclusive, non-transferable license to use the app for your personal use in accordance with these terms.")

                    Text("5. Bluetooth and Connectivity")
                        .bold()
                    Text("Bluetooth performance may vary by device. MedPez is not responsible for any missed doses due to disconnection, low battery, or pairing failures.")

                    Text("6. Limitations of Liability")
                        .bold()
                    Text("We are not liable for any loss, harm, or injury resulting from the use of this app, including but not limited to missed medications, incorrect entries, or device errors.")

                    Text("7. Privacy Policy")
                        .bold()
                    Text("Your use of MedPez is also subject to our Privacy Policy, which outlines how your personal and health-related data is collected, used, and stored.")

                    Text("8. Termination")
                        .bold()
                    Text("We reserve the right to suspend or terminate access to the app at our discretion, including for violations of these terms.")

                    Text("9. Governing Law")
                        .bold()
                    Text("These terms are governed by the laws of the State of California, without regard to conflict of law principles.")

                    Text("10. Changes to Terms")
                        .bold()
                    Text("We may update these Terms of Service at any time. Continued use of the app after changes indicates acceptance of the revised terms.")

                    Text("11. Contact")
                        .bold()
                    Text("For any questions regarding these terms, please contact us at medpez.study@gmail.com.")

                    Text("Effective Date: May 1, 2025")
                    Text("Last Updated: May 5, 2025")
                }
            }
            .font(.custom("OpenSans-Regular", size: 16))
            .padding()
        }
    }
}

#Preview {
    TermsOfServiceView()
}
