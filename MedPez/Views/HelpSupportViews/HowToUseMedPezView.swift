//
//  HowToUseMedPezView.swift
//  MedPez
//
//  Created by Brian Lee on 4/21/25.
//  Updated on 5/7/25
//

import SwiftUI

struct HowToUseMedPezView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("How to Use MedPez Device")
                    .font(.custom("OpenSans-Bold", size: 28))

                Group {
                    StepView(number: 1, description: "Ensure Bluetooth is turned on in your iPhone's settings.")

                    StepView(number: 2, description: "In the MedPez app, tap the 'My Device' button on the dashboard, or go to Profile > Settings > My Device, then tap 'Connect' to pair your device.")

                    StepView(number: 3, description: "Once connected, the device will automatically sync with your medication schedule.")

                    StepView(number: 4, description: "At your scheduled dose time, manually  dispense the pill by pressing the dispense button and mark the dose as completed automatically.")

                    StepView(number: 5, description: "You can view the remaining pills in your device and toggle reminders directly from the device screen.")

                    StepView(number: 6, description: "If needed, you can manually disconnect or reconnect your device from the same 'My Device' section.")
                }

                Text("For additional support, visit the Support Center in Settings.")
                    .font(.custom("OpenSans-Regular", size: 16))
                    .foregroundColor(.gray)
                    .padding(.top, 10)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("How to Use MedPez")
        .navigationBarTitleDisplayMode(.inline)
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
    HowToUseMedPezView()
}
