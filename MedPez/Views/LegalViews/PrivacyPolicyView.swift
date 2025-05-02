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
                    Text("- Personal Information: Name, email, and birthdate (entered during registration or profile setup).\n- Medication Data: Your medication schedules, dosage, and task completion status.\n- Bluetooth Device Data: Connection status and pill count data from the MedPez smart dispenser.")
                    
                    Text("2. How We Use Your Information")
                        .bold()
                    Text("- To provide personalized reminders and medication tracking.\n- To connect and interact with your MedPez pill dispenser.\n- To maintain user profiles and preferences.")
                    
                    Text("3. Data Storage")
                        .bold()
                    Text("- Data is stored securely using Firebase Firestore and Firebase Authentication.\n- We use industry-standard encryption and authentication practices.")
                    
                    Text("4. Third Parties")
                        .bold()
                    Text("- We do not sell or share your personal information with third-party advertisers.\n- Data may be processed by Firebase (a service provided by Google) for app functionality.")
                    
                    Text("5. Your Rights")
                        .bold()
                    Text("- You can request access to or deletion of your data by contacting us at [medpez.study@gmail.com].")
                    
                    Text("6. Children’s Privacy")
                        .bold()
                    Text("- This app is not intended for use by children under 13.")
                    
                    Text("7. Contact Us")
                        .bold()
                    Text("If you have any questions, contact us at [medpez.study@gmail.com].")
                    
                    Text("Effective Date: May 1, 2025")
                    Text("Last Updated: May 1, 2025")
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
