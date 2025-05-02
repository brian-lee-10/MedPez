//
//  TermsOfServiceView.swift
//  MedPez
//
//  Created by Brian Lee on 5/1/25.
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
                    Text("By using MedPez, you agree to the following terms:")

                    Text("1. Use of the App")
                        .bold()
                    Text("You must be 13 or older to use this app. MedPez is for personal use only and not a substitute for medical advice.")

                    Text("2. Account Responsibility")
                        .bold()
                    Text("You are responsible for maintaining the security of your account and information.")

                    Text("3. No Medical Advice")
                        .bold()
                    Text("The app provides medication tracking and reminders, but does not provide medical or pharmaceutical advice.")

                    Text("4. Bluetooth and Connectivity")
                        .bold()
                    Text("Bluetooth connections may vary by device. MedPez is not liable for missed doses due to connectivity issues.")

                    Text("5. Limitations of Liability")
                        .bold()
                    Text("We are not responsible for any loss, injury, or harm related to missed medication or incorrect data entry.")

                    Text("6. Changes")
                        .bold()
                    Text("We may update these terms. Continued use of the app constitutes acceptance of the revised terms.")
                    
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
    TermsOfServiceView()
}
