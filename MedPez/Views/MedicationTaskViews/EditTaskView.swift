//
//  EditTaskView.swift
//  MedPez
//
//  Created by Brian Lee on 5/4/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct EditTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Bindable var task: Task

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .tint(.red)
                }
                Spacer()
            }

            Text("Edit Medication")
                .font(.custom("OpenSans-Bold", size: 24))

            VStack(alignment: .leading, spacing: 8, content: {
                Text("Medication Name")
                    .font(.custom("OpenSans-Bold", size:16))
                    .foregroundStyle(.black)
                
                TextField("Medication Name", text: $task.taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
            })
            

            VStack(alignment: .leading, spacing: 8, content: {
                Text("Dosage (mg)")
                    .font(.custom("OpenSans-Bold", size:16))
                    .foregroundStyle(.black)
                
                TextField("Dosage (mg)", text: $task.dosage)
                    .keyboardType(.decimalPad)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
                
            })
            
            VStack(alignment: .leading, spacing: 8, content: {
                DatePicker("Date", selection: $task.creationDate)
                    .font(.custom("OpenSans-Bold", size:16))
                    .foregroundStyle(.black)
                    .datePickerStyle(.compact)
                    .padding()
            })

            Toggle("Mark as Completed", isOn: $task.isCompleted)
                .padding(.horizontal)
                .font(.custom("OpenSans-Bold", size:16))
                .foregroundStyle(.black)

            Button("Save Changes") {
                saveChanges()
            }
            .font(.custom("OpenSans-Bold", size: 22))
            .foregroundStyle(.white)
            .hSpacing(.center)
            .padding(.vertical, 12)
            .background(Color("SlateBlue"), in: .rect(cornerRadius: 10))
        }
        .padding(15)
    }

    private func saveChanges() {
        guard let userId = Auth.auth().currentUser?.uid,
              let firebaseId = task.firebaseId else {
            print("Missing user ID or Firebase document ID")
            return
        }

        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("medications")
            .document(firebaseId)
            .updateData([
                "taskTitle": task.taskTitle,
                "dosage": task.dosage,
                "taskDate": Timestamp(date: task.creationDate),
                "taskComplete": task.isCompleted
            ]) { error in
                if let error = error {
                    print("Error updating task: \(error.localizedDescription)")
                } else {
                    do {
                        try context.save()
                        NotificationManager.cancelNotification(for: task)

                        if !task.isCompleted {
                            NotificationManager.scheduleNotification(for: task)
                        }
                        dismiss()
                    } catch {
                        print("Error saving context: \(error.localizedDescription)")
                    }
                }
            }
    }
}


#Preview {
    struct PreviewWrapper: View {
        @State private var showSheet = true

        var body: some View {
            Button("Edit Task") {
                showSheet.toggle()
            }
            .sheet(isPresented: $showSheet) {
                // Provide a dummy task for previewing
                EditTaskView(task: Task(
                    taskTitle: "Aspirin",
                    creationDate: Date(),
                    isCompleted: false,
                    dosage: "100",
                    firebaseId: "mock_id"
                ))
                .presentationDetents([.height(600)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
            }
        }
    }

    return PreviewWrapper()
}
