//
//  NewTaskView.swift
//  MedPez
//
//  Created by Brian Lee on 2/20/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NewTaskView: View {
    /// View Properties
    @Environment(\.dismiss) private var dismiss
    /// Model Content For Saving Data
    @Environment(\.modelContext) private var context
    
    
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskDosage: String = ""
    @State private var taskComplete: Bool = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    @AppStorage("medicationDataConsentGiven") private var consentGiven: Bool = false
    @State private var showConsentDialog = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            })
            .hSpacing(.leading)
            
            /// Medication Name Field
            VStack(alignment: .leading, spacing: 8, content: {
                Text("Medication Name")
                    .font(.custom("OpenSans-Bold", size:16))
                    .foregroundStyle(.black)
                
                TextField("Enter Medication Name", text: $taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
            })
            .padding(.top, 5)
            
            
            
            /// Number of Pills Field
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Dosage (mg)")
                        .font(.custom("OpenSans-Bold", size:16))
                        .foregroundStyle(.black)
                    
                    TextField("Enter Dosage", text: $taskDosage)
                        .keyboardType(.decimalPad)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 15)
                        .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 2)), in: .rect(cornerRadius: 10))
                })
            }
            
            /// Date and Task Color
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Date")
                        .font(.custom("OpenSans-Bold", size:16))
                        .foregroundStyle(.black)
                    
                    HStack {
                        DatePicker("", selection: $taskDate)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                        Spacer()
                    }
                    .scaleEffect(0.9, anchor: .leading)

                })
                /// Giving Some Space for tapping
                .padding(.trailing, -15)
                
                Spacer()
                
            }
            .padding(.top, 5)
            
            Spacer(minLength: 0)
            
            Button(action: {
                if consentGiven {
                    saveMedicationFirebase()
                } else {
                    showConsentDialog = true
                }
            }, label: {
                Text("Add Medication")
                    .font(.custom("OpenSans-Bold", size: 22))
                    .foregroundStyle(.white)
                    .hSpacing(.center)
                    .padding(.vertical, 12)
                    .background(Color("SlateBlue"), in: .rect(cornerRadius: 10))
            })
            .disabled(taskTitle == "")

        })
        .padding(15)
        .alert("Consent to Store Medication Data", isPresented: $showConsentDialog) {
            Button("Cancel", role: .cancel) {}
            Button("I Consent") {
                consentGiven = true
                saveMedicationFirebase()
                saveConsentToFirebase()
            }
        } message: {
            Text("By adding your medication details, you consent to MedPez securely storing this information on our servers. You can delete your data at any time in Settings.")
        }
    }
    
    private func saveConsentToFirebase() {
        guard let user = Auth.auth().currentUser else {
            print("User not authenticated")
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        userRef.setData([
            "medicationConsentGiven": true,
            "consentGivenDate": FieldValue.serverTimestamp()
        ], merge: true) { error in
            if let error = error {
                print("❌ Error saving consent: \(error.localizedDescription)")
            } else {
                print("✅ Consent saved to Firebase.")
                consentGiven = true
            }
        }
    }

    
    private func saveMedicationFirebase() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let db = Firestore.firestore()
        let taskData: [String: Any] = [
            "taskTitle": taskTitle,
            "taskDate": Timestamp(date: taskDate),
            "taskComplete": taskComplete,
            "dosage": taskDosage
        ]

        var docRef: DocumentReference? = nil
        docRef = db.collection("users")
            .document(userId)
            .collection("medications")
            .addDocument(data: taskData) { error in
                if let error = error {
                    print("Error saving to Firestore: \(error.localizedDescription)")
                } else if let firebaseId = docRef?.documentID {
                    let task = Task(
                        taskTitle: taskTitle,
                        creationDate: taskDate,
                        dosage: taskDosage,
                        firebaseId: firebaseId
                    )
                    do {
                        context.insert(task)
                        try context.save()
                        
                        if notificationsEnabled {
                            NotificationManager.scheduleNotification(for: task)
                        }

                        dismiss()
                    } catch {
                        print("Error saving to SwiftData: \(error.localizedDescription)")
                    }
                }
            }
    }

}

#Preview {
    NewTaskView()
        .vSpacing(.bottom)
}

