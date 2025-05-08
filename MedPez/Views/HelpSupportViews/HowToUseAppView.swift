//
//  HowToUseAppView.swift
//  MedPez
//
//  Created by Brian Lee on 4/15/25.
//  Updated on 5/7/25.
//

import SwiftUI

struct HowToUseAppView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("How to Use MedPez App")
                    .font(.custom("OpenSans-Bold", size: 28))
                    .padding(.bottom, 5)

                Group {
                    StepView(number: 1, description: "Tap 'Add Medication' on the Dashboard, or tap the '+' button on the Calendar page to add a new medication.")

                    StepView(number: 2, description: "Set a time and dosage amount for each medication.")

                    StepView(number: 3, description: "View your next upcoming dose on the Dashboard.")

                    StepView(number: 4, description: "View all scheduled doses by date in the Calendar view.")

                    StepView(number: 5, description: "When a pill is dispensed from the MedPez device, the dose is automatically marked as completed. You can also mark it manually by tapping the circle next to the task.")

                    StepView(number: 6, description: "Pair your MedPez device by tapping the 'My Device' button on the Dashboard or by going to Profile > Settings > My Device.")

                    StepView(number: 7, description: "Turn notifications on or off by tapping the 'My Device' button on the Dashboard.")

                    StepView(number: 8, description: "Edit your profile details in the Profile tab.")

                    StepView(number: 9, description: "Contact support or access emergency services from the Help and Support page.")

                }

                Text("Need more help? Visit the Support Center in Settings.")
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
    HowToUseAppView()
}
