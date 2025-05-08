//
//  HowToConnectView.swift
//  MedPez
//
//  Created by Brian Lee on 4/21/25.
//  Updated on 5/7/25
//

import SwiftUI

struct HowToConnectView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("How to Pair MedPez Device")
                    .font(.custom("OpenSans-Bold", size: 28))
                    .padding(.bottom, 5)

                Group {
                    StepView(number: 1, description: "Go to Settings > Bluetooth on your iPhone and make sure Bluetooth is turned on.")

                    StepView(number: 2, description: "When prompted, allow MedPez to use Bluetooth. You can also enable this in Settings > Privacy & Security > Bluetooth.")

                    StepView(number: 3, description: "Open the MedPez app. Tap 'My Device' on the Dashboard, or go to Profile > Settings > My Device.")

                    StepView(number: 4, description: "Select your MedPez device from the list to pair. A 'Connected' badge will confirm successful pairing.")

                    StepView(number: 5, description: "Allow notifications when prompted so you can receive timely medication reminders.")
                }

                Text("Still need help? Visit the Support Center in Settings.")
                    .font(.custom("OpenSans-Regular", size: 16))
                    .foregroundColor(.gray)
                    .padding(.top, 10)

                Spacer()
            }
            .padding()
        }
    }

    @ViewBuilder
    func StepView(number: Int, description: String) -> some View {
        HStack(alignment: .top) {
            Text("\(number).")
                .font(.custom("OpenSans-Bold", size: 20))
                .frame(width: 30, alignment: .leading)

            Text(description)
                .font(.custom("OpenSans-Regular", size: 18))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    HowToConnectView()
}
