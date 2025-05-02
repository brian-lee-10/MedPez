import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SwiftData

struct NextDoseDetailView: View {
    let title: String
    let dosage: String
    let date: Date
    let documentId: String
    let hasNextDose: Bool  // <-- NEW

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    @State private var isCompleted = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Next Dose Details")
                .font(.custom("OpenSans-Bold", size: 28))

            if hasNextDose {
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
                .padding()
            } else {
                Text("There is nothing.")
                    .font(.custom("OpenSans-Regular", size: 20))
                    .foregroundColor(.gray)
                    .padding()
            }

            Spacer()

            Button("Close") {
                dismiss()
            }
            .font(.custom("OpenSans-Bold", size: 18))
        }
        .padding()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        return formatter.string(from: date)
    }

    private func updateCompletionStatus(to status: Bool) {
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
                    updateLocalTaskCompletion(to: status)
                    if status {
                        dismiss()
                    }
                }
            }
    }

    private func updateLocalTaskCompletion(to status: Bool) {
        do {
            let descriptor = FetchDescriptor<Task>(
                predicate: #Predicate<Task> { task in
                    task.firebaseId == documentId
                }
            )

            if let taskToUpdate = try context.fetch(descriptor).first {
                taskToUpdate.isCompleted = status
                try context.save()
            }
        } catch {
            print("Error updating local SwiftData task: \(error.localizedDescription)")
        }
    }
}
