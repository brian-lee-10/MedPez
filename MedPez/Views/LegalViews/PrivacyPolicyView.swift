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
                    - Personal Information: Name, email address, and optional birthdate (entered during registration or profile setup).
                    - Medication Data: Medication names, scheduled times, dosages, and task completion status.
                    - Bluetooth Device Data: Pill count and connection status from the MedPez smart pill dispenser.
                    - Device & Usage Data: Anonymous app usage and device identifiers for performance and troubleshooting (non-personal).
                    """)

                    Text("2. How We Use Your Information")
                        .bold()
                    Text("""
                    - To provide personalized medication reminders and tracking.
                    - To sync and interact with your MedPez Bluetooth device.
                    - To customize your user profile and preferences.
                    - To improve app functionality and user experience.
                    """)

                    Text("3. Consent")
                        .bold()
                    Text("""
                    By creating an account or adding medication data, you consent to the collection and storage of your health-related information for the purposes stated above.
                    You can withdraw consent at any time by deleting your account or contacting us.
                    """)

                    Text("4. Data Storage and Security")
                        .bold()
                    Text("""
                    - All data is stored using Google Firebase Firestore and Firebase Authentication.
                    - We use encryption, authentication, and secure access protocols to protect your information.
                    - Only authenticated users can access their data.
                    """)

                    Text("5. Data Retention and Deletion")
                        .bold()
                    Text("""
                    - We retain your data for as long as your account is active.
                    - You may delete your data at any time through the app's settings.
                    - Upon account deletion, your data is permanently removed from our systems.
                    """)

                    Text("6. Sharing with Third Parties")
                        .bold()
                    Text("""
                    - We do not sell or rent your personal information to advertisers or marketers.
                    - Data is processed only by Firebase (a Google service) for functionality and authentication.
                    """)

                    Text("7. Your Rights")
                        .bold()
                    Text("""
                    - You have the right to access, update, or delete your personal data.
                    - You may also contact us to request data export or to withdraw consent.
                    """)

                    Text("8. Children’s Privacy")
                        .bold()
                    Text("""
                    - MedPez is not intended for children under the age of 17.
                    - We do not knowingly collect data from children under 17. If we discover such data, we will delete it.
                    """)

                    Text("9. Changes to This Policy")
                        .bold()
                    Text("""
                    - We may update this Privacy Policy to reflect changes in law or app functionality.
                    - We encourage you to review this policy periodically.
                    """)

                    Text("10. Contact Us")
                        .bold()
                    Text("""
                    If you have any questions or concerns, please contact us at: medpez.study@gmail.com
                    """)

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
    PrivacyPolicyView()
}
