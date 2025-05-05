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
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .tint(.red)
                }
                Spacer()
            }
            
            Text("Next Dose Details")
                .font(.custom("OpenSans-Bold", size: 28))

            if hasNextDose {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Next Dose")
                            .font(.custom("OpenSans-Bold", size: 22))
                            .foregroundColor(Color("SlateBlue"))
                        Spacer()
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "pills.fill")
                                .foregroundColor(.blue)
                            Text("Medication: \(title)")
                        }

                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.purple)
                            Text("Dosage: \(dosage) mg")
                        }

                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.orange)
                            Text("Scheduled At: \(formattedDate(date))")
                        }

                        Toggle(isOn: $isCompleted) {
                            Text("Mark as Taken")
                                .font(.custom("OpenSans-Regular", size: 18))
                        }
                        .toggleStyle(SwitchToggleStyle(tint: Color("SlateBlue")))
                        .onChange(of: isCompleted) { _, newValue in
                            updateCompletionStatus(to: newValue)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                }
                .padding()
            } else {
                Text("No Next Dose")
                    .font(.custom("OpenSans-Regular", size: 20))
                    .foregroundColor(.gray)
                    .padding()
            }

            Spacer()
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
