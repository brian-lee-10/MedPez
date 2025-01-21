//
//  AddMedicationView.swift
//  MedPez
//
//  Created by Brian Lee on 1/21/25.
//
import SwiftUI


struct AddMedicationView: View {
    var body: some View {
        VStack {
            Text("Add Medication")
                .font(.largeTitle)
                .padding()

            Text("This is where users can add new medications.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
    }
}

//#Preview {
//    AddMedicationView()
//}
