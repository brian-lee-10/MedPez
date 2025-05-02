//
//  NextDoseDetailView.swift
//  MedPez
//
//  Created by Brian Lee on 5/2/25.
//

import SwiftUI
import SwiftData
import FirebaseFirestore
import FirebaseAuth

struct NextDoseDetailView: View {
    let title: String
    let dosage: String
    let date: Date
    let documentId: String
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @State private var isCompleted = false
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .hSpacing(.leading)
            
            Text("Next Dose Details")
                .font(.custom("OpenSans-Bold", size: 28))

            VStack(alignment: .leading, spacing: 8) {
                Text("Medication: \(title)")
                Text("Dosage: \(dosage) mg")
                Text("Scheduled At: \(formattedDate(date))")
                Toggle("Mark as Taken", isOn: $isCompleted)
                    .onChange(of: isCompleted) { _, newValue in
                        updateCompletionStatus(to: newValue)
                    }
            }
            .font(.custom("OpenSans-Regular", size: 18))
            .foregroundStyle(Color.black)
            .padding()

            Spacer()
        }
        .padding()
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        return formatter.string(from: date)
    }

    func updateCompletionStatus(to status: Bool) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("medications")
            .document(documentId)
            .updateData(["taskComplete": status]) { error in
                if let error = error {
                    print("Error updating task: \(error.localizedDescription)")
                } else {
                    // ✅ Optional: Update local SwiftData model
                    updateLocalTaskCompletion(to: status)

                    // ✅ Auto-dismiss
                    if status {
                        dismiss()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            dismiss()
//                        }
                    }
                }
            }
    }

    private func updateLocalTaskCompletion(to status: Bool) {
        let fetchDescriptor = FetchDescriptor<Task>(
            predicate: #Predicate { $0.firebaseId == documentId }
        )
        if let taskToUpdate = try? context.fetch(fetchDescriptor).first {
            taskToUpdate.isCompleted = status
            try? context.save()
        }
    }

}
