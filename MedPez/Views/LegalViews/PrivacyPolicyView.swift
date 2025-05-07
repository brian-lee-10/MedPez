//
//  PrivacyPolicyView.swift
//  MedPez
//
//  Created by Brian Lee on 5/1/25.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Privacy Policy")
                    .font(.custom("OpenSans-Bold", size: 28))
                    .padding(.bottom, 5)

                Group {
                    Text("MedPez respects your privacy. This Privacy Policy explains how we collect, use, and protect your information when you use our mobile application.")

                    Text("1. Information We Collect")
                        .bold()
                    Text("""
                    - **Personal Information**: Your name, email address, and optional birthdate (provided during registration or profile setup).
                    - **Medication Data**: Medication names, scheduled times, dosages, and task completion status entered by the user.
                    - **Bluetooth Device Data**: Pill count and connection status from the MedPez smart pill dispenser.
                    - **Device & Usage Data**: Anonymous app usage data and device identifiers used solely for performance monitoring and troubleshooting.
                    """)

                    Text("2. How We Use Your Information")
                        .bold()
                    Text("""
                    - To provide personalized medication reminders and tracking.
                    - To sync and communicate with your MedPez Bluetooth device.
                    - To customize and maintain your user profile and preferences.
                    - To improve app performance, reliability, and user experience.
                    """)

                    Text("3. Consent")
                        .bold()
                    Text("""
                    By creating an account or entering medication data, you consent to the collection and secure storage of your health-related information for the purposes outlined in this policy.
                    You may withdraw your consent at any time by deleting your account or contacting our support team.
                    """)

                    Text("4. Data Storage and Security")
                        .bold()
                    Text("""
                    - All data is securely stored using Google Firebase Firestore and Firebase Authentication.
                    - We use encryption, authentication, and access controls to protect your data.
                    - Only authenticated users have access to their personal information.
                    """)

                    Text("5. Data Retention and Deletion")
                        .bold()
                    Text("""
                    - Your data is retained for as long as your account remains active.
                    - You may delete your data at any time via the app’s Settings.
                    - Upon account deletion, all data is permanently removed from our systems.
                    """)

                    Text("6. Sharing with Third Parties")
                        .bold()
                    Text("""
                    - We do not sell, rent, or share your personal information with advertisers or marketing companies.
                    - Your data is processed only by Google Firebase services to provide app functionality and authentication.
                    """)

                    Text("7. Your Rights")
                        .bold()
                    Text("""
                    - You may request access to, update, or delete your personal data at any time.
                    - You may also contact us to request a data export or to revoke consent.
                    """)

                    Text("8. Children’s Privacy")
                        .bold()
                    Text("""
                    - MedPez is not intended for children under the age of 17.
                    - We do not knowingly collect data from users under 17. If such data is found, it will be deleted immediately.
                    """)

                    Text("9. Changes to This Policy")
                        .bold()
                    Text("""
                    - We may update this Privacy Policy to reflect changes in law or app functionality.
                    - We encourage users to review this policy periodically for any updates.
                    """)

                    Text("10. Contact Us")
                        .bold()
                    Text("""
                    If you have any questions or concerns regarding this Privacy Policy, please contact us at: medpez.study@gmail.com
                    """)

                    Text("Effective Date: May 1, 2025")
                    Text("Last Updated: May 7, 2025")

                }
            }
            .font(.custom("OpenSans-Regular", size: 16))
            .padding()
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
